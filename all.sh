#!/bin/bash

oldv=`cat version`
rdfv=`gdialog --title "Version Number" --inputbox "Enter Version Number (Currently $oldv)" 300 450 2>&1`
if [ "$rdfv" == "" ]
then
echo "No input, exiting."
exit 0
fi

xhtmlu=`gdialog --title "Update Notes" --inputbox "Enter Update Notes" 300 450 2>&1`

# Chrome

echo $rdfv > chrome.version

echo '{
  "name": "World Tipitaka",
  "version": "'$rdfv'",
  "description": "Offline version of the World Tipitaka.",
  "icons": { 
  "48": "images/logo48.png",
  "128": "images/logo128.png" },
  "background_page": "background.html",
  "update_url": "https://capslock.accountservergroup.com/~sirimang/pali/WTchrome.xml",
  "browser_action": {
    "default_title": "World Tipitaka",
    "default_icon": "images/logo24.png"
  },
  "permissions": [
    "tabs"
  ]
}
' > manifest.json

echo '<?xml version="1.0" encoding="UTF-8"?>
<gupdate xmlns="http://www.google.com/update2/response" protocol="2.0">
  <app appid="pkfdgapihandbfkkkppjklphcbcdjndk">
    <updatecheck codebase="https://capslock.accountservergroup.com/~sirimang/pali/WTChrome.crx" version="'$rdfv'" />
  </app>
</gupdate>
' > chrome.xml

# Firefox

cd WTFirefox
echo $rdfv > version
echo "var version='$rdfv';" > content/version.js

echo '<?xml version="1.0" encoding="UTF-8"?>
<RDF xmlns="http://www.w3.org/1999/02/22-rdf-syntax-ns#" 
 xmlns:em="http://www.mozilla.org/2004/em-rdf#">
  <Description about="urn:mozilla:install-manifest">
    <em:id>worldtipitaka@noah.yuttadhammo</em:id>
    <em:name>World Tipitaka</em:name>
    <em:version>'$rdfv'</em:version>
    <em:creator>Noah Yuttadhammo</em:creator>
    <em:description>Off-line edition of the World Tipitaka.</em:description>
    <em:homepageURL>http://pali.sirimangalo.org/</em:homepageURL>
    <em:optionsURL>chrome://worldtipitaka/content/options.xul</em:optionsURL>
    <em:updateURL>https://capslock.accountservergroup.com/~sirimang/pali/worldtipitaka.rdf</em:updateURL>
    <em:targetApplication>
      <Description>
        <em:id>{ec8030f7-c20a-464f-9b0e-13a3a9e97384}</em:id> <!-- firefox -->
        <em:minVersion>1.5</em:minVersion>
        <em:maxVersion>4.*</em:maxVersion>
      </Description>
    </em:targetApplication>
  </Description>
</RDF>
' > install.rdf

echo '<?xml version="1.0" encoding="UTF-8"?>

<RDF:RDF xmlns:RDF="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
         xmlns:em="http://www.mozilla.org/2004/em-rdf#">
  <RDF:Description about="urn:mozilla:extension:worldtipitaka@noah.yuttadhammo">
    <em:updates>
      <RDF:Seq>
        <RDF:li>
          <RDF:Description>
            <em:version>'$rdfv'</em:version>
            <em:targetApplication>
              <RDF:Description>
                <em:id>{ec8030f7-c20a-464f-9b0e-13a3a9e97384}</em:id>
                <em:minVersion>1.5</em:minVersion>
                <em:maxVersion>4.*</em:maxVersion>
                <em:updateLink>https://capslock.accountservergroup.com/~sirimang/pali/WTFirefox.xpi</em:updateLink>
                <em:updateInfoURL>https://capslock.accountservergroup.com/~sirimang/pali/worldtipitaka.xhtml</em:updateInfoURL>
              </RDF:Description>
            </em:targetApplication>
          </RDF:Description>
        </RDF:li>
      </RDF:Seq>
    </em:updates>
  </RDF:Description>
</RDF:RDF>
' > worldtipitaka.rdf

echo "$xhtmlu" > worldtipitaka.xhtml

cd ..

git add .
git commit -m "$xhtmlu" -a
git push
