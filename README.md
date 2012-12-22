[XMLspectrum](http://qutoric.com/xslt/xmlspectrum) =========================== for XPath 2.0, XSLT 2.0, XSD 1.1, XML----------------------------------------A principal XSLT 2.0 stylesheet and supporting stylesheets  that convert XSLT 2.0, XSD 1.1, XML or XPath 2.0 source code to HTML with syntax highlighting.- Syntax highlighter- Code formatter- Hyperlinker*Image of sample output rendered in browser:*![Screenshot](http://www.qutoric.com/xslt/xmlspectrum/images/xsl-light.png)Emphasis on accurate rendering of XPath 2.0 expressions, either within XSLT/XSD or standalone.By default,  *all* formatting is preserved exactly as-is - with trim and formatting options### Syntax Highlighting Features:- Processes plain-text or XML- Optionally processes xsl:include and xsl:import referenced XSLT- Uses standard XSLT 2.0 - no extensions required (tested on Saxon-HE)- Uses [Solarized](http://ethanschoonover.com/solarized) color light/dark color themes- Generates the required CSS file also - depending on theme specified- 2 interface stylesheet samples supplied:	- *highlight-file.xsl*		- Identifies XML coloring scheme from root namespace (for XML)		- Accepts either plain-text or XML files	- *highlight-inline.xsl*		- Highlights numerous incomplete code samples embedded in host XHTML file                      - Designed to be extended to support XMLspec- XPath Highlighting:	- Supports XPath Comments	- All whitespace formatting preserved	- No dependency on reserved keywords           - Standalone files supported - or embedded in XML- XML Highlighting	- Built-in XML parser (coded in XSLT) keeps all text, as-is	- CDATA preserved intact and highlighted- XSLT 2.0 Highlighting	- Scheme colors help separate instructions from expressions           - Literal Result Elements have different coloring	- XPath colored for AVTs or native XPath attributes	- All formatting preserved- XSD 1.1 Highlighting	- Element and Attribute definition elements highlighted	- XPath coloring for *test* attribute in *assert* element### Formatting Features:- Formatting including whitespace between attributes and within attribute contents preserved by default- XML content is shown exactly as in the source - including intact entity references and CDATA sections etc.- [Option] *Indent*	- Indents XML proportional to the nesting level (Same as standard formatters)	- Smart attribute formatting (advanced feature)		- Aligned vertically with indentation consistent with the host element		- Multi-line content vertically aligned with pre-existing indentation preserved- [Option] *Auto-Trim*	- Removes pre-existing indentation (normally combined with the indent option)##Web Samples[demo output of Docbook XSLT 2.0 Project](http://qutoric.com/samples/docbook20demo/)[XMLSpectrum (highlight-file.xsl entry-file) run on itself](http://qutoric.com/samples/xmlspectrum-code/)### Cross-referencing Features Recursively processes all XSLT modules from a top-level stylesheet- Adds hyperlinks for:	- *xsl:include* and *xsl:import* hrefs	- Global Parameters	- Global Variables	- Standard Functions	- User-defined Functions	- Named Templates### Sample Implementations (that include xmlspectrum.xsl)- *highlight-inline.xsl* - transforms XHTML file containing descriptive text and XSLT, XSD or XPath code examples-  *highlight-file.xsl*     - transforms files containing only XSLT,XSD or XPath*The dark theme:*![Screenshot](http://www.qutoric.com/xslt/xmlspectrum/images/xsd-dark.png)	- 