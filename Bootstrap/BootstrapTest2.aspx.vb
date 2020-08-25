
Partial Class BootstrapTest2
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As System.EventArgs) Handles Me.Load

    End Sub

    Protected Sub Page_PreRender(sender As Object, e As System.EventArgs) Handles Me.PreRender
        TextBox3.Attributes.Add("onchange", "javascript:callchange(this);")
        TextBox3.Attributes.Add("onblur", "javascript:callblur(this);")
        TextBox3.Attributes.Add("onkeydown", "javascript:this.value=this.value.toUpperCase(); var x = window.event.keyCode;console.log('x:::: '+ x ); if(x==9){   var getExplorer = (function() { var explorer = window.navigator.userAgent, compare = function(s) { return (explorer.indexOf(s) >= 0); }, ie11 = (function() { return ('ActiveXObject' in window) })(); if (compare('MSIE') || ie11) { return 'ie'; } else if (compare('Firefox') && !ie11) { return 'Firefox'; } else if (compare('Chrome') && !ie11) { return 'Chrome'; }})();if (getExplorer  =='ie') {          $(this).trigger('change');console.log('changeON'); event.preventDefault();  }  }")
    End Sub

End Class
