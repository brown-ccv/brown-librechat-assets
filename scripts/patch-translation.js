window.addEventListener('load', () => {
    const patch = {
      "com_auth_welcome_back": "Welcome Brown Student",
      "another_key": "Patched value"
    };
  
    const tryPatch = () => {
      if (window.i18next) {
        window.i18next.addResources('en', 'translation', patch);
      } else {
        setTimeout(tryPatch, 200); // wait until i18next is ready
      }
    };
  
    tryPatch();
  });