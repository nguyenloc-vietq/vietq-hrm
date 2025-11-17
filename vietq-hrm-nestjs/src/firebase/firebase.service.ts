import { Inject, Injectable, Logger } from "@nestjs/common";
import * as admin from "firebase-admin";

@Injectable()
export class FirebaseService {
  private readonly logger = new Logger(FirebaseService.name);

  constructor(
    @Inject("FIREBASE_ADMIN") private readonly firebaseApp: admin.app.App,
  ) {}

  async sendNotification(token: string, title: string, body: string) {
    const message = {
      token,
      notification: {
        title,
        body,
      },
      android: {
        priority: "high" as const,
      },
      apns: {
        payload: {
          aps: {
            alert: {
              title,
              body,
            },
            sound: "default",
          },
        },
      },
    };

    try {
      const response = await this.firebaseApp.messaging().send(message);
      this.logger.log("Notification sent successfully:", response);
      return response;
    } catch (error) {
      this.logger.error("Error sending notification:", error);
      throw error;
    }
  }
}
