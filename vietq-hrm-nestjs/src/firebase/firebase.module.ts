import { Module, Global } from "@nestjs/common";
import * as admin from "firebase-admin";
import { FirebaseService } from "./firebase.service";
import { ConfigService } from "@nestjs/config";
import firebaseKey from "./firebase-key.json";

@Global()
@Module({
  providers: [
    {
      provide: "FIREBASE_ADMIN",
      useFactory: () => {
        return admin.initializeApp({
          credential: admin.credential.cert(
            firebaseKey as admin.ServiceAccount,
          ),
        });
      },
    },
    FirebaseService,
  ],
  exports: ["FIREBASE_ADMIN", FirebaseService],
})
export class FirebaseModule {}
