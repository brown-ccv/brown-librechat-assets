window.addEventListener('load', () => {
    const patch = {
      "some_translation_key": "Your hotfix string",
      "another_key": "Patched value"
    };
  
    const tryPatch = () => {
      if (window.i18next) {
        window.i18next.addResources('th', 'translation', patch);
      } else {
        setTimeout(tryPatch, 200); // wait until i18next is ready
      }
    };
  
    tryPatch();
  });