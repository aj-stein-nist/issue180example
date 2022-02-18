# issue180example

This is a collection of sample applications to reproduce bug report in issue [#180](https://github.com/usnistgov/metaschema/issues/180) for Metaschema, a development tool NIST uses to make [OSCAL](https://pages.nist.gov/OSCAL).

This exhibits a potential bug in the SaxonJS library in its implementation and support of the [`accumulator-after` function](https://www.saxonica.com/html/documentation10/functions/fn/accumulator-after.html) of the [XSLT 3.0 specification](https://www.w3.org/TR/xslt-30/#accumulators).

At this time, it consists of the following applications.

- saxonjs-example

## Test Fixure Data

The example identity transform (working), and the failing accumulator transforms are kept alongside test data (`example.xml`) in [`./test/fixtures`](./test/fixtures).

Results will be saved locally (and configured to not be stored with `git` however) in [`./test/results`](./test/results).

## saxon-example

TBD, but running current versions of the Java JAR of Saxon HE in the 10.6.x release cycle work with similar transforms and handle the `accumulator-after` function, with or without a namespace. It does not throw a runtime error. A similar Java application will potentially be developed, in place of executing the transform with the `java -cp ~/.m2/repository/net/sf/saxon/Saxon-HE/10.6/Saxon-HE-10.6.jar net.sf.saxon.Transform` approach.

## saxonjs-example

To run this sample application run you will enter the sub-directory and enter the following commands.

```sh
$ git clone https://github.com/aj-stein-nist/issue180example.git
$ pushd issues180example/saxonjs-example
$ npm run test
```

The following output will always occur, where the identity transform compiles to a valid SEF with `xslt3`, but accumulator files fail to compile with `xslt3` with the following errors.

```sh
Failed to compile stylesheet: Static error in XPath on line 17 in fixtures/accumulator_simple.xsl {accumulator-after('total-items')}: Unknown accumulator Q{}total-items
Error Q{http://www.w3.org/2005/xqt-errors}XTDE3340 at xpath.xsl#963
    Failed to compile stylesheet:
Error Q{http://www.w3.org/2005/xqt-errors}XTDE3340 at xpath.xsl#963
    Static error in XPath on line 17 in fixtures/accumulator_simple.xsl {accumulator-after('total-items')}: Unknown accumulator Q{}total-items
Failed to compile stylesheet: Static error in XPath on line 27 in fixtures/accumulator_basic.xsl {accumulator-after('total-items')}: Unknown accumulator Q{}total-items
Error Q{http://www.w3.org/2005/xqt-errors}XTDE3340 at xpath.xsl#963
    Failed to compile stylesheet:
Error Q{http://www.w3.org/2005/xqt-errors}XTDE3340 at xpath.xsl#963
    Static error in XPath on line 27 in fixtures/accumulator_basic.xsl {accumulator-after('total-items')}: Unknown accumulator Q{}total-items
Failed to compile stylesheet: Static error in XPath on line 28 in fixtures/accumulator_namespaces.xsl {accumulator-after('example:total-items')}: Unknown accumulator Q{https://example.com/ns/custom/0.1}total-items
Error Q{http://www.w3.org/2005/xqt-errors}XTDE3340 at xpath.xsl#963
    Failed to compile stylesheet:
Error Q{http://www.w3.org/2005/xqt-errors}XTDE3340 at xpath.xsl#963
    Static error in XPath on line 28 in fixtures/accumulator_namespaces.xsl {accumulator-after('example:total-items')}: Unknown accumulator Q{https://example.com/ns/custom/0.1}total-items
```