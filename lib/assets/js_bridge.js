(function() {
  'use strict';
  
  if (window.flutterJsEvalInject) {
    return;
  }

  window.flutterJsEvalInject = {
    addJavascriptFile: function(filePath) {
      return new Promise(function(resolve, reject) {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.src = filePath;
        
        script.onload = function() {
          resolve();
        };
        
        script.onerror = function() {
          reject(new Error('Failed to load script: ' + filePath));
        };
        
        document.head.appendChild(script);
      });
    },
    
    addJavascriptCode: function(code) {
      try {
        var script = document.createElement('script');
        script.type = 'text/javascript';
        script.textContent = code;
        document.head.appendChild(script);
        return Promise.resolve();
      } catch (error) {
        return Promise.reject(error);
      }
    },
    
    evalJavascript: function(codeToEval) {
      try {
        var result = eval(codeToEval);
        return Promise.resolve(result);
      } catch (error) {
        return Promise.reject(error);
      }
    }
  };
})();