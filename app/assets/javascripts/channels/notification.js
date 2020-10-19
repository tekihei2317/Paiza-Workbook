App.notification = App.cable.subscriptions.create("NotificationChannel", {
  connected: function () { },
  disconnected: function () { },
  received: function (data) {
    return alert(data['message']);
  },
  display: function (message) {
    return this.perform('display', {
      message: message
    });
  }
});