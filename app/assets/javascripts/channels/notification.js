App.notification = App.cable.subscriptions.create("NotificationChannel", {
  connected: function () { },
  disconnected: function () { },
  received: function (data) {
    return alert(`${data['email']} ${data['password']}`);
  },
  display: function (email, password) {
    return this.perform('display', {
      email: email,
      password: password
    });
  }
});