import {
  create,
  get,
  parseCreationOptionsFromJSON,
  parseRequestOptionsFromJSON,
} from "@github/webauthn-json/browser-ponyfill";

export default (options = {}) => ({
  error: false,
  credential: null,

  createCredential() {
    if (!window.PublicKeyCredential) {
      this.error = true;
      return;
    }

    const parsedOptions = parseCreationOptionsFromJSON({ publicKey: options });

    create(parsedOptions)
      .then((credential) => {
        this.credential = JSON.stringify(credential);
      })
      .catch((error) => {
        console.error(error);
        this.error = true;
      });
  },

  checkCredential() {
    if (!window.PublicKeyCredential) {
      this.error = true;
      return;
    }

    const parsedOptions = parseRequestOptionsFromJSON({ publicKey: options });

    get(parsedOptions)
      .then((credential) => {
        this.credential = JSON.stringify(credential);
        this.$nextTick(() => {
          this.$refs.form.submit();
        });
      })
      .catch((error) => {
        console.error(error);
        this.error = true;
      });
  },
});
