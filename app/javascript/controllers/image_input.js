export default (initialImage = "", imagePresent = false) => ({
  image: initialImage,
  showImage: imagePresent,

  changeImage(event) {
    const file = event.target.files[0];

    const reader = new FileReader();

    reader.onload = (event) => {
      this.image = event.target.result;
    };

    reader.readAsDataURL(file);

    this.showImage = true;
  },
});
