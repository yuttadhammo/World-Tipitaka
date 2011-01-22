
function loadWT() {
    var theTab          = gBrowser.addTab('chrome://worldtipitaka/content/');
    theTab.label        = "World Tipitaka";
    gBrowser.selectedTab = theTab;
	var func = function () { gBrowser.setIcon(theTab, "chrome://worldtipitaka/skin/icons/logo.png"); };
	setTimeout(func, 500);
}
