#  Bugs

1. The first thing I see is resume is not being called on fetch and create message threads on in the MessageThreadController.
2. In the create message thread IBAction on the message thread table view controller, the app crashes because we are trying to reload the table view but on a background thread.
3. Once I am able to create a message thread on the app, when I go to add a new message to that thread, I click save and nothing happens. I will need to look into this further to determine why.
4. The app is getting a decoding error, "Expected to decode Array<Any> but found a dictionary instead." I will need to look over the JSON being returned and how the init from decoder is set up on the message thread model.
