import SubmitController from "controllers/submit_controller"
import { DirectUpload } from "@rails/activestorage";

export default class extends SubmitController {
  static targets = ["input", "button", "delete_button"];

  connect() {
    super.connect();
    this.form = this.element.closest("form");
  }

  upload(event) {
    const file = event.target.files[0];
    if (file) this.uploadFile(file);
  }

  open() {
    this.inputTarget.click();
  }

  drop(event) {
    event.preventDefault();
    this.buttonTarget.classList.remove("dragging");
    const file = event.dataTransfer.files[0];
    if (file) this.uploadFile(file);
  }

  dragover(event) {
    event.preventDefault();
  }

  dragenter(event) {
    event.preventDefault();
    this.buttonTarget.classList.add("dragging");
  }

  dragleave(event) {
    event.preventDefault();
    this.buttonTarget.classList.remove("dragging");
  }

  deleteFile() {
    this.addHiddenInput("account_profile[remove_avatar]", 1);
    this.form.requestSubmit();
  }

  uploadFile(file) {
    const input = this.inputTarget;
    const upload = new DirectUpload(file, input.dataset.directUploadUrl);

    upload.create((error, blob) => {
      if (error) {
        console.error(error);
        return;
      }

      this.addHiddenInput(input.name, blob.signed_id)
      this.form.requestSubmit();
    });
  }

  addHiddenInput(name, value) {
    const hiddenInput = document.createElement("input");
    hiddenInput.type = "hidden";
    hiddenInput.name = name;
    hiddenInput.value = value;
    this.form.appendChild(hiddenInput);
  }
}
