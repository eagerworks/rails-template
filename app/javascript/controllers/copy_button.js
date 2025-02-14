export default (initialText = "", copyText = "") => ({
  buttonText: initialText,

  copy() {
    navigator.clipboard.writeText(copyText);
    this.buttonText = "Copied!";
    setTimeout(() => {
      this.buttonText = initialText;
    }, 1000);
  },
});
