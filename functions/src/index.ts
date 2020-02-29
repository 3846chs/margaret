import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendNotification = functions
    .region("asia-northeast1")
    .firestore.document("Chats/{groupId1}/{groupId2}/{message}")
    .onCreate(async (snapshot, context) => {
        console.log("----------------start function--------------------");

        const doc = snapshot.data() as FirebaseFirestore.DocumentData;
        console.log(doc);

        const idFrom: string = doc.idFrom;
        const idTo: string = doc.idTo;

        // Get push token user to (receive)
        const snapshotTo = await admin
            .firestore()
            .collection("Users")
            .doc(idTo)
            .get();
        const userTo = snapshotTo.data() as FirebaseFirestore.DocumentData;
        console.log(`Found user to: ${userTo.nickname}`);

        // Get info user from (sent)
        const snapshotFrom = await admin
            .firestore()
            .collection("Users")
            .doc(idFrom)
            .get();
        const userFrom = snapshotFrom.data() as FirebaseFirestore.DocumentData;
        console.log(`Found user from: ${userFrom.nickname}`);

        const title: string = userFrom.nickname;
        const body: string =
            doc.type === 0 ? doc.content : "사진을 보냈습니다.";

        const registrationToken: string = userTo.pushToken;
        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: title,
                body: body,
                badge: "1",
                sound: "default",
                tag: idFrom
            }
        };
        // Let push to the target device
        admin
            .messaging()
            .sendToDevice(registrationToken, payload)
            .then(response => {
                console.log("Successfully sent message:", response);
            })
            .catch(error => {
                console.log("Error sending message:", error);
            });
        return null;
    });
