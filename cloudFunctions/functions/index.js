const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

// // Create and deploy your first functions
// // https://firebase.google.com/docs/functions/get-started
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

const db = admin.firestore();


exports.checkStreaks = functions.pubsub
    .schedule("0 0 * * *")
    .timeZone("America/New_York")
    .onRun((context) => {
      return db
          .collection("users")
          .get()
          .then((users) => {
            users.forEach((user) => {
              db.collection("users")
            .doc(user.id)
            .collection("tasks")
            .get()
            .then((tasks) => {
              tasks.forEach((task) => {
                db.collection("users")
                  .doc(user.id)
                  .collection("tasks")
                  .doc(task.id)
                  .get()
                  .then((currentTask) => {
                    let data = currentTask.data()
                    // console.log(yesterday(), data.daysCompleted[data.daysCompleted.length - 1].toDate())
                    // if (data.daysCompleted[data.daysCompleted.length - 1].toDate().getTime() != yesterday.getTime()) {
                    db
                        .collection("users")
                        .doc(user.id)
                        .collection("tasks")
                        .doc(task.id)
                        .update({
                            completedToday: false
                        })

                    if (!sameDay(yesterday(), data.daysCompleted[data.exactTimes.length - 1].toDate())) {
                        
                        console.log("Streak reset condition met for: ", data.name, "by ", user.id)
                        console.log(yesterday().toLocaleDateString(), data.daysCompleted[data.exactTimes.length - 1].toDate().toLocaleDateString())
                        db
                            .collection("users")
                            .doc(user.id)
                            .collection("tasks")
                            .doc(task.id)
                            .update({
                                currentStreak: 0
                            })
                    }
                  })
                  .catch((err) => {
                    console.log(err);
                  });
              });
            })
            .catch((err) => {
              console.log(err);
            });
        });
      })
      .catch((err) => {
        console.log(err);
      });
  });


  function sameDay(d1, d2) {
    return d1.getFullYear() === d2.getFullYear() &&
      d1.getMonth() === d2.getMonth() &&
      d1.getDate() === d2.getDate();
  }

  function yesterday() {  
    const yesterday = new Date()
    yesterday.setDate(yesterday.getDate() - 1)
    return yesterday
  }