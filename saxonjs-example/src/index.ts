import { ChildProcess, spawn } from 'child_process';
import * as fs from 'fs';
import * as path from 'path';
import * as SaxonJS from 'saxon-js';

enum FileTypes {
    TRANSFORM_SOURCE = '.xsl',
    TRANSFORM_COMPILED = '.sef.json',
    TRANSFORM_TARGET = '.xml'
}

export async function transform(compiledTransformsPath: string, documentPath: string, resultDocumentPath: string) {
    try {
        const documentFullPath: string = path.resolve(documentPath);
        const resultDocumentFullPath: string = path.resolve(resultDocumentPath);
        const compiledTransforms = fs.readdirSync(compiledTransformsPath).filter(
            fn => fn.endsWith(FileTypes.TRANSFORM_COMPILED)
        );
    
        compiledTransforms.forEach(ct =>{
            const targetDocument = `${resultDocumentFullPath}${path.sep}${path.basename(documentFullPath)}_${ct}${FileTypes.TRANSFORM_TARGET}`;
            let transformation = (SaxonJS.transform({
                stylesheetLocation: `${compiledTransformsPath}${path.sep}${ct}`,
                sourceFileName: documentFullPath,
                destination: "serialized"
            }, "async") as Promise<DocumentFragment>)
            .then((result: any) => {
                const documentData: string = result.principalResult;
                fs.writeFileSync(targetDocument, documentData);
            }).catch(err => {
                console.error(`Failed to transform to '${documentFullPath}' with '${ct}' and save to '${targetDocument}'`);
                console.error(err);
            }
            );
        });
    } catch(err) {
        console.log(err);
    }
}

export async function compile(transformsPath: string, compiledTransformsPath: string) {
    const commandPath = path.resolve('node_modules/.bin/xslt3')
    const compiledExtension = FileTypes.TRANSFORM_COMPILED;
    let transforms: string[];

    try {
        transforms = fs.readdirSync(transformsPath).filter(fn => fn.endsWith(FileTypes.TRANSFORM_SOURCE));
    } catch(err) {
        console.error(`Bad path for source transforms in '${transformsPath}'`);
        console.error(err);
        return;
    }
    
    const compilations: Promise<any>[] = [];

    transforms.forEach(t => {
        const filename = path.basename(t);
        const source = `${transformsPath}${path.sep}${filename}`;
        const target = `${compiledTransformsPath}${path.sep}${filename}${compiledExtension}`
        console.log(`transformation of transform ${t} to ${target}`);

        let promise = new Promise(function(resolve, reject) {
            const process: ChildProcess = spawn(
                commandPath,
                [
                 `-xsl:${source}`,
                 `-export:${target}`,
                 '-nogo'
                ],
                {
                    stdio: 'inherit',
                    shell: true
                }
            );

            process.on('close', function(result) {
                resolve(result);
            });

            process.on('error', function(err) {
                reject(err);
            });
        });

        compilations.push(promise);
    });

    try {
        const results = await Promise.all(compilations);
        return results;
    } catch (err) {
        console.error(err);
    }
}

(async () => {
    try {
        await compile('../test/fixtures', 'dist');
        await transform('dist', '../test/fixtures/example.xml', '../test/results');
    } catch (err) {
        console.log(err)
    }
})();
