import { Application } from "@hotwired/stimulus";

const application = Application.start();

// Configure Stimulus development experience
application.debug = false;
window.Stimulus = application;

export { application };

Turbo.StreamActions.reload_frame = function () {
  const frame = document.getElementById(this.target)
  frame?.reload()
}
