
<div id="test_cookie" style="position: absolute; top: -10000px"></div>

  window.setTimeout(function() {
    if (document.cookie.indexOf('test_cookie=1') < 0) {
      var      
        name = 'test_cookie',
        div = document.getElementById(name),
        iframe = document.createElement('iframe'),
        form = document.createElement('form');

      iframe.name = name;
      iframe.src = 'javascript:false';
      div.appendChild(iframe);

      form.action = location.toString();
      form.method = 'POST';
      form.target = name;
      div.appendChild(form);

      form.submit();
    }
  }, 10);