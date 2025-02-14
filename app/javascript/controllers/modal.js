// TODO: check turbo frame load

export default () => ({
  isOpen: false,

  open() {
    console.log("open!");
    this.isOpen = true;
  },
  close() {
    this.isOpen = false;
  },
  handleFormSubmit(event) {
    if (event.detail.success) {
      this.close();
    }
  },
});
