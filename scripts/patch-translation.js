window.addEventListener('load', () => {
    const patch = {
      "com_auth_welcome_back": "Welcome Brown Student",
      "another_key": "Patched value"
    };
  
    const tryPatch = () => {
      if (window.i18next) {
        window.i18next.addResources('en', 'translation', patch);
        window.i18next.reloadResources('en');
        window.i18next.changeLanguage('en');
      } else {
        setTimeout(tryPatch, 200); // wait until i18next is ready
      }
    };
  
    tryPatch();
  });