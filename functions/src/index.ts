import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

export const sendMatchAlarm = functions
    .region("asia-northeast1")
    .firestore.document("Users/{userId}/TodayQuestions/{questionId}")
    .onUpdate(async (snapshot, context) => {
        const userId: string = context.params.userId;
        const userSnapshot = await admin
            .firestore()
            .collection("Users")
            .doc(userId)
            .get();
        const user = userSnapshot.data() as FirebaseFirestore.DocumentData;
        const registrationToken: string = user.pushToken;
        if (!registrationToken || registrationToken.length === 0) return null;

        const match: boolean = user.alarms.match;
        if (!match) return null;

        const before = snapshot.before.data as FirebaseFirestore.DocumentData;
        const after = snapshot.after.data as FirebaseFirestore.DocumentData;

        const beforeList: String[] = before.recommendedPeople;
        const afterList: String[] = after.recommendedPeople;

        if (
            afterList?.length !== 3 ||
            afterList?.length === beforeList?.length
        ) {
            console.log(beforeList);
            console.log(afterList);
            return null;
        }

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "새로운 이성이 매칭되었습니다!",
                body: "확인하시려면 클릭하세요.",
                badge: "1",
                sound: "default",
                tag: "match"
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

export const sendPeerQuestionAlarm = functions
    .region("asia-northeast1")
    .firestore.document("Users/{userId}/PeerQuestions/{questionId}")
    .onCreate(async (snapshot, context) => {
        const userId: string = context.params.userId;
        const userRef = admin
            .firestore()
            .collection("Users")
            .doc(userId);
        const userSnapshot = await userRef.get();
        const user = userSnapshot.data() as FirebaseFirestore.DocumentData;

        const registrationToken: string = user.pushToken;
        if (!registrationToken || registrationToken.length === 0) return null;

        const newPeerQuestion: boolean = user.alarms.newPeerQuestion;
        if (!newPeerQuestion) return null;

        const questionsSnapshot = await userRef
            .collection("PeerQuestions")
            .get();
        if (questionsSnapshot.size !== 1) return null;

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "새로운 질문이 들어왔습니다!",
                body: "확인하시려면 클릭하세요.",
                badge: "1",
                sound: "default",
                tag: "match"
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

export const sendMyQuestionAlarm = functions
    .region("asia-northeast1")
    .firestore.document("Users/{userId}/MyQuestions/{questionId}")
    .onCreate(async (snapshot, context) => {
        const userId: string = context.params.userId;
        const userRef = admin
            .firestore()
            .collection("Users")
            .doc(userId);
        const userSnapshot = await userRef.get();
        const user = userSnapshot.data() as FirebaseFirestore.DocumentData;

        const registrationToken: string = user.pushToken;
        if (!registrationToken || registrationToken.length === 0) return null;

        const newMyQuestion: boolean = user.alarms.newMyQuestion;
        if (!newMyQuestion) return null;

        const questionsSnapshot = await userRef.collection("MyQuestions").get();
        if (questionsSnapshot.size !== 1) return null;

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "질문에 답변이 들어왔습니다!",
                body: "확인하시려면 클릭하세요.",
                badge: "1",
                sound: "default",
                tag: "match"
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

export const sendReceiveAlarm = functions
    .region("asia-northeast1")
    .firestore.document("Users/{userId}/Receives/{peerId}")
    .onCreate(async (snapshot, context) => {
        const userId: string = context.params.userId;
        const userSnapshot = await admin
            .firestore()
            .collection("Users")
            .doc(userId)
            .get();
        const user = userSnapshot.data() as FirebaseFirestore.DocumentData;
        const registrationToken: string = user.pushToken;
        if (!registrationToken || registrationToken.length === 0) return null;

        const receive: boolean = user.alarms.receive;
        if (!receive) return null;

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "새로운 이성이 호감을 보냈습니다!",
                body: "확인하시려면 클릭하세요.",
                badge: "1",
                sound: "default",
                tag: "receive"
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

export const sendNewChatAlarm = functions
    .region("asia-northeast1")
    .firestore.document("Users/{userId}/Chats/{peerId}")
    .onCreate(async (snapshot, context) => {
        const userId: string = context.params.userId;
        const userSnapshot = await admin
            .firestore()
            .collection("Users")
            .doc(userId)
            .get();
        const user = userSnapshot.data() as FirebaseFirestore.DocumentData;
        const registrationToken: string = user.pushToken;
        if (!registrationToken || registrationToken.length === 0) return null;

        const newChat: boolean = user.alarms.newChat;
        if (!newChat) return null;

        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: "새로운 이성과 채팅이 연결되었습니다!",
                body: "확인하시려면 클릭하세요.",
                badge: "1",
                sound: "default",
                tag: "newChat"
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

export const deleteUser = functions
    .region("asia-northeast1")
    .https.onCall(async (data, context) => {
        const id: string = data.id ?? (await admin.auth().getUserByEmail(data.email)).uid;
        await admin.auth().deleteUser(id);
        return {};
    });

export const createToken = functions
    .region("asia-northeast1")
    .https.onCall(async (data, context) => {
        const id: string = data.id;
        const email: string = data.email;

        console.log("creating a firebase user");

        const updateParams: admin.auth.CreateRequest = {
            displayName: email
        };

        console.log(updateParams);

        const userRecord = await admin
            .auth()
            .updateUser(id, updateParams)
            .catch(error => {
                if (error.code === "auth/user-not-found") {
                    updateParams.uid = id;
                    updateParams.email = email;
                    return admin.auth().createUser(updateParams);
                }
                throw error;
            });
        const userId = userRecord.uid;

        console.log(`creating a custom firebase token based on uid ${userId}`);

        return { firebaseToken: await admin.auth().createCustomToken(userId) };
    });

export const sendNotification = functions
    .region("asia-northeast1")
    .firestore.document("Chats/{groupId1}/{groupId2}/{message}")
    .onCreate(async (snapshot, context) => {
        console.log("----------------start function--------------------");

        const doc = snapshot.data() as FirebaseFirestore.DocumentData;
        console.log(doc);

        const idFrom: string = doc.idFrom;
        const idTo: string = doc.idTo;

        if (!idTo || idTo.length === 0) return null;

        // Get push token user to (receive)
        const snapshotTo = await admin
            .firestore()
            .collection("Users")
            .doc(idTo)
            .get();
        const userTo = snapshotTo.data() as FirebaseFirestore.DocumentData;
        console.log(`Found user to: ${userTo.nickname}`);

        const registrationToken: string = userTo.pushToken;
        if (!registrationToken || registrationToken.length === 0) return null;

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
