var jQuery;
var MyRegistryEmbed = { isEasyXDMLoaded: null, isJqueryLoaded: null, socket: null, mainPanelContainer: '#div_iframe_container', Initialize: function () {
  this.SetScript();
  this.SetPanel();
}, CreateContainer: function () {
  var container = document.createElement('div');
  container.id = this.mainPanelContainer.replace('#', '').replace('.', '');
  jQuery(container).css('border', '0');
  return container;
}, SetScript: function () {
  MyRegistryEmbed.LoadJquery();
  MyRegistryEmbed.CreateEasyXDM();
}, CreateEasyXDM: function () {
  var documentBody = document.getElementsByTagName('body')[0];
  var scriptTag = document.createElement('script');
  scriptTag.id = 'MyRegistryEasyXDM';
  scriptTag.type = 'text/javascript';
  scriptTag.src = '//www.myregistry.com/Scripts/easyXDM/easyXDM.min.js';
  if (scriptTag.readyState) {
    scriptTag.onreadystatechange = function () {
      if (this.readyState == 'complete' || this.readyState == 'loaded') {
        MyRegistryEmbed.isEasyXDMLoaded = true;
      }
    };
  } else {
    scriptTag.onload = function () {
      MyRegistryEmbed.isEasyXDMLoaded = true;
    };
  }
  documentBody.appendChild(scriptTag);
}, LoadJquery: function () {
  if (jQuery) {
    MyRegistryEmbed.isJqueryLoaded = true;
    return;
  }
  var scriptSet = '//www.myregistry.com/ScriptSet/MrJqueryScripts.js';
  var scriptLoaded = function () {
    MyRegistryEmbed.isJqueryLoaded = true;
    try {
      jQuery = jQuery.noConflict(true);
    } catch (e) {
    }
  };
  var scriptTag = document.createElement('script');
  scriptTag.id = 'MyRegistryInitializeScript';
  scriptTag.setAttribute('type', 'text/javascript');
  scriptTag.setAttribute('src', scriptSet);
  if (scriptTag.readyState) {
    scriptTag.onreadystatechange = function () {
      if (this.readyState == 'complete' || this.readyState == 'loaded') {
        scriptLoaded();
      }
    };
  } else {
    scriptTag.onload = function () {
      scriptLoaded();
    };
  }
  if (document.getElementsByTagName('head').length > 0) {
    document.getElementsByTagName('head')[0].appendChild(scriptTag);
  } else if (document.getElementsByTagName('body').length > 0) {
    document.getElementsByTagName('body')[0].appendChild(scriptTag);
  } else {
    alert('An error has occurred. Please try again later.');
  }
}, GetParentOffsetTop: function (obj) {
  var curleft = 0;
  var curtop = 0;
  if (obj) {
    if (typeof obj.offsetParent != 'undefined' && obj.offsetParent) {
      do {
        if (typeof obj != 'undefined' && obj && typeof obj.offsetParent != 'undefined' && obj.offsetParent) {
          curtop += obj.offsetTop;
        } else {
          break;
        }
      } while (obj = obj.offsetParent);
    }
  }
  return { x: curleft, y: curtop };
}, GetScrollTop: function (message) {
  var functionName = message.split(';')[1];
  var giftId = message.split(';')[2];
  if (functionName != 'ClipixButtonClick') {
    var top = jQuery(window).scrollTop() - (MyRegistryEmbed.GetParentOffsetTop(document.getElementById('div_iframe_container')).y - 150);
    if (top < 0) {
      top = 100;
    }
    var scrollTop = 'SetScrollTop;' + top + ';' + functionName + ';' + giftId;
    MyRegistryEmbed.socket.postMessage(scrollTop);
  } else {
    if (document.getElementById) {
      var x = document.getElementsByTagName('head').item(0);
      var o = document.createElement('script');
      if (typeof (o) != 'object') {
        o = document.standardCreateElement('script');
      }
      o.setAttribute('src', (('https:' == document.location.protocol) ? 'https://www.clipix.com/' : 'http://www.clipix.com/') + '/WebServices/HttpCombiner.ashx?set=ClipButton&type=text/javascript&r=2&version=' + (new Date().getTime()));
      o.setAttribute('type', 'text/javascript');
      x.appendChild(o);
    }
  }
}, SetPanel: function () {
  var panelInterval = setInterval(function () {
    if (MyRegistryEmbed.isJqueryLoaded && MyRegistryEmbed.isEasyXDMLoaded) {
      clearInterval(panelInterval);
      var container = MyRegistryEmbed.CreateContainer();
      jQuery('#script_myregistry_giftlist_iframe').parent().append(container);
      MyRegistryEmbed.socket = new easyXDM.Socket({ remote: 'http://www.myregistry.com/ExternalApps/EmbededVistorView/Visitors/GiftList.aspx?registryId=654195&pageSize=10000&bindtype=embed', container: container, props: { style: { width: '100%', height: '2522px', display: 'block' } }, onMessage: function (message, origin) {
        var functionName = message.split(';')[0];
        switch (functionName) {
          case 'GetScrollTop':
            MyRegistryEmbed.GetScrollTop(message);
            break;
          case 'Resize':
            MyRegistryEmbed.Resize(null, message.split(';')[1]);
            break;
        }
      }, onReady: function () {
      } });
    }
  }, 100);
}, Resize: function (width, height) {
  var iframe = jQuery('#script_myregistry_giftlist_iframe').parent().find('iframe')[0];
  if (iframe) {
    jQuery(iframe).css('height', height + 'px');
  }
} };
MyRegistryEmbed.Initialize();