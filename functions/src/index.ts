import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendNotification = functions.firestore
    .document("Chats/{groupId1}/{groupId2}/{message}")
    .onCreate(async (snapshot, context) => {
        console.log("----------------start function--------------------");

        const doc = snapshot.data() as FirebaseFirestore.DocumentData;
        console.log(doc);

        const idFrom = doc.idFrom;
        const idTo = doc.idTo;
        const contentMessage = doc.content;

        // Get push token user to (receive)
        const userToDoc = await admin
            .firestore()
            .collection("Users")
            .doc(idTo)
            .get();
        const userTo = userToDoc.data() as FirebaseFirestore.DocumentData;
        console.log(`Found user to: ${userTo.nickname}`);

        // Get info user from (sent)
        const userFromDoc = await admin
            .firestore()
            .collection("Users")
            .doc(idFrom)
            .get();
        const userFrom = userFromDoc.data() as FirebaseFirestore.DocumentData;
        console.log(`Found user from: ${userFrom.nickname}`);

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: `You have a message from "${userFrom.nickname}"`,
                body: contentMessage,
                badge: "1",
                sound: "default",
                tag: idFrom
            }
        };
        // Let push to the target device
        admin
            .messaging()
            .sendToDevice(String(userTo.pushToken), payload)
            .then(response => {
                console.log("Successfully sent message:", response);
            })
            .catch(error => {
                console.log("Error sending message:", error);
            });
        return null;
    });
