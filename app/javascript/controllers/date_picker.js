import flatpickr from "flatpickr";

export default (format = "Y-m-d") => ({
  init() {
    flatpickr(this.$el, {
      dateFormat: format,
    });
  },
});
