export default (options = {}) => ({
  error: false,
  credential: null,

  create() {
    if (!window.PublicKeyCredential) {
      this.error = true;
      return;
    }

    console.log(options);
    options.challenge = new Uint8Array(options.challenge);
    options.user.id = new Uint8Array(options.user.id);

    // options.pubKeyCredParams.forEach((param) => {
    //   param.type = "publicKey";
    // });

    navigator.credentials
      .create({ publicKey: options })
      .then((credential) => {
        console.log(credential);
        this.credential = JSON.stringify(credential);
        console.log(this.$refs);
        this.$nextTick(() => {
          this.$refs.form.submit();
        });
      })
      .catch((error) => {
        console.log(error);
      });
  },
});
