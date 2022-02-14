import 'package:web_scraper/web_scraper.dart';

class WebScraperService {
  void getPDGAData(int pdgaNumber) async {
    final webScraper = WebScraper('https://www.pdga.com/');
    if (await webScraper.loadWebPage('player/$pdgaNumber').catchError((e) {
      print(e);
    })) {
      List<Map<String, dynamic>> elements =
          webScraper.getElement('div.page clearfix', []);
      print(elements);
      print(webScraper.getPageContent());
    }
  }
}
/*
<div id="zone-branding-wrapper" class="zone-wrapper zone-branding-wrapper clearfix">
<div id="zone-branding" class="zone zone-branding clearfix container-16">
<div class="grid-11 region region-branding" id="region-branding">
<div class="region-inner region-branding-inner">
<div class="branding-data clearfix">
<div class="logo-img">
<a href="/" rel="home" title=""><img src="https://www.pdga.com/sites/all/themes/pdga/logo.png" alt="" id="logo"></a> </div>
</div>
</div>
</div><div class="grid-5 region region-user-bar" id="region-user-bar">
<div class="region-inner region-user-bar-inner">
<div class="block block-panels-mini block-header-user-bar block-panels-mini-header-user-bar odd block-without-title" id="block-panels-mini-header-user-bar">
<div class="block-inner clearfix">
<div class="content clearfix">
<div class="panel-display panel-1col clearfix" id="mini-panel-header_user_bar">
<div class="panel-panel panel-col">
<div><div class="panel-pane pane-custom pane-1 pane-social-links inline clearfix">
<div class="pane-content">
<ul class="menu social-links"><li><a class="twitter" href="https://twitter.com/pdga" target="_blank" title="PDGA on Twitter" rel="noopener noreferrer">Twitter</a></li>
<li><a class="instagram" href="https://instagram.com/pdga" target="_blank" title="PDGA on Instagram" rel="noopener noreferrer">Instagram</a></li>
<li><a class="facebook" href="https://www.facebook.com/pdga" target="_blank" title="PDGA on Facebook" rel="noopener noreferrer">Facebook</a></li>
<li><a class="flickr" href="https://www.flickr.com/photos/pdga/" target="_blank" title="PDGA on Flickr" rel="noopener noreferrer">Flickr</a></li>
<li><a class="youtube" href="https://www.youtube.com/user/pdgamedia" target="_blank" title="PDGA on YouTube" rel="noopener noreferrer">YouTube</a></li>
<li><a class="linkedin" href="https://www.linkedin.com/groups?gid=31030" target="_blank" title="PDGA on LinkedIn" rel="noopener noreferrer">LinkedIn</a></li>
</ul> </div>
</div>
<div class="panel-separator"></div><div class="panel-pane pane-pdga-search-searchapi-block pane-search-form">
<h2 class="pane-title">
Search </h2>
<div class="pane-content">
<div class="container-inline">
<form class="search-form" action="/search" method="get" id="search-form" accept-charset="UTF-8">
<div>
<div class="form-item form-type-textfield form-item-keywords">
<input type="text" name="keywords" autocorrect="off" value="" size="15" maxlength="128" class="form-text">
</div>
</div>
<div class="form-actions">
<input type="submit" value="Search" class="form-submit">
</div>
</form>
</div>
</div>
</div>
<div class="panel-separator"></div><div class="panel-pane pane-block pane-system-user-menu inline">
<div class="pane-content">
<ul class="menu"><li class="first leaf"><a href="/user/login?destination=player/132408" title="">Login</a></li>
<li class="leaf"><a href="/membership" title="">Join &amp; Renew</a></li>
<li class="last leaf"><a href="/contact" title="">Contact</a></li>
</ul> </div>
</div>
</div>
</div>
</div>
</div>
</div>
</div> </div>
</div> </div>
</div>
*/
