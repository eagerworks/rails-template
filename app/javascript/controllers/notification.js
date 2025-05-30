export default () => ({
  isOpen: false,

  init() {
    this.$dispatch("notification:initialized");

    this.$nextTick(() => {
      this.isOpen = true;
    });
  },

  close() {
    this.isOpen = false;
    window.setTimeout(() => {
      this.$el.remove();
    }, 75);
  },

  replace() {
    this.close();
  },
});
