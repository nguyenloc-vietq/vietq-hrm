/* eslint-disable @typescript-eslint/no-explicit-any */
import { HttpException, Injectable } from "@nestjs/common";

import { CodeGeneratorService } from "../code-generator/code-generator.service";
import { CreateNotificationDto } from "./dto/create-notification.dto";
import { DatabaseService } from "../database/database.service";
import { DevicesRegisterNotificationDto } from "./dto/devicesRegister-notification.dto";
import { FirebaseService } from "../firebase/firebase.service";
import { UpdateNotificationDto } from "./dto/update-notification.dto";
import dayjs from "dayjs";

@Injectable()
export class NotificationService {
  constructor(
    private readonly prisma: DatabaseService,
    private codeGen: CodeGeneratorService,
    private firebaseService: FirebaseService,
  ) {}
  async devicesRegister(
    dataRegister: DevicesRegisterNotificationDto,
    req: any,
  ) {
    try {
      //chekFcmToken is exits

      const exitsDevices = await this.prisma.userDevice.findFirst({
        where: {
          userCode: req.user.userCode,
        },
      });

      const exitsFcmToken = await this.prisma.userDevice.findFirst({
        where: {
          AND: {
            fcmToken: dataRegister.fcmToken,
            userCode: {
              not: req.user.userCode,
            },
          },
        },
      });
      if (exitsFcmToken) {
        await this.prisma.userDevice.update({
          where: {
            id: exitsFcmToken.id,
            fcmToken: dataRegister.fcmToken,
          },
          data: {
            isActive: false,
          },
        });
      }
      if (exitsDevices) {
        const updateDevices = await this.prisma.userDevice.update({
          where: {
            userCode: req.user.userCode,
          },
          data: {
            ...dataRegister,
            isActive: true,
          },
        });
        return updateDevices;
      } else {
        const newDevices = await this.prisma.userDevice.create({
          data: {
            ...dataRegister,
            userCode: req.user.userCode,
          },
        });
        return newDevices;
      }
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async devicesStatus(userCode: string) {
    try {
      const devices = await this.prisma.userDevice.update({
        where: {
          userCode: userCode,
        },
        data: {
          isActive: false,
        },
      });
      return devices;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async listNotification(userCode: string) {
    try {
      const listAllNotification = await this.prisma.notification.findMany({
        where: {
          targetType: "ALL",
        },
        select: {
          notificationCode: true,
          title: true,
          targetType: true,
          typeSystem: true,
          scheduleTime: true,
          isSent: true,
          openSent: true,
          isActive: true,
          createdAt: true,
          updatedAt: true,
        },
        orderBy: {
          createdAt: "desc",
        },
      });
      const listNotification = await this.prisma.userNotification.findMany({
        where: {
          userCode: userCode,
        },
        include: {
          notification: {
            select: {
              notificationCode: true,
              title: true,
              targetType: true,
              typeSystem: true,
              scheduleTime: true,
              isSent: true,
              openSent: true,
              isActive: true,
              createdAt: true,
              updatedAt: true,
            },
          },
        },
        orderBy: {
          createdAt: "desc",
        },
      });
      const notiAll = listAllNotification.map((item) => ({
        notification: item,
      }));
      const result = [...notiAll, ...listNotification];

      return result;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async detailNotification(userCode: string, notificationCode: string) {
    try {
      const notiTypeAll = await this.prisma.notification.findFirst({
        where: {
          notificationCode: notificationCode,
          targetType: "ALL",
        },
      });
      if (notiTypeAll) {
        return {
          notification: notiTypeAll,
        };
      }
      const detailNotification = await this.prisma.userNotification.findFirst({
        where: {
          AND: {
            userCode: userCode,
            notificationCode: notificationCode,
          },
        },
        include: {
          notification: true,
        },
      });
      return { ...detailNotification };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async userReadNotification(userCode: string, notificationCode: string) {
    try {
      //check notification is exits

      const notification = await this.prisma.userNotification.findFirst({
        where: {
          userCode: userCode,
          notificationCode: notificationCode,
        },
        select: {
          id: true,
        },
      });

      if (!notification) {
        throw new HttpException("Notification not found", 404);
      }
      const userNotification = await this.prisma.userNotification.update({
        where: {
          userCode_notificationCode: {
            userCode: userCode,
            notificationCode: notificationCode,
          },
        },
        data: {
          isRead: true,
          readAt: dayjs().toDate(),
        },
      });
      return userNotification;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async userRemoveNotification(userCode: string, notificationCode: string) {
    try {
      const userNotification = await this.prisma.userNotification.update({
        where: {
          userCode_notificationCode: {
            userCode: userCode,
            notificationCode: notificationCode,
          },
        },
        data: {
          isActive: false,
        },
      });
      return userNotification;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async adminCreateNotification(createNotification: CreateNotificationDto) {
    try {
      const notificationCode = await this.codeGen.generateCode(
        this.prisma.notification,
        "NOT",
        {
          field: "notificationCode",
        },
      );
      const { listUserCode, ...dataNoti } = createNotification;
      const notification = await this.prisma.notification.create({
        data: {
          notificationCode: notificationCode,
          ...dataNoti,
        },
      });
      console.log(
        `[===============> createNotification.scheduleTime | `,
        createNotification.scheduleTime,
      );
      if (
        createNotification.isSent === true &&
        createNotification.scheduleTime === undefined
      ) {
        await this.prisma.userNotification.createMany({
          data: listUserCode.map((item) => ({
            userCode: item,
            notificationCode: notificationCode,
          })),
        });
        const listToken = await this.prisma.userDevice.findMany({
          where: {
            userCode: {
              in: listUserCode,
            },
            isActive: true,
          },
          select: {
            fcmToken: true,
          },
        });
        if (listToken.length > 0) {
          listToken.map(async (item) => {
            await this.sendNotification({
              token: item.fcmToken,
              title: createNotification.title,
              body: createNotification.body,
              data: {
                notificationid: notificationCode,
              },
            });
          });
        }
      }
      if (createNotification.targetType === "ALL") {
        await this.firebaseService.sendNotificationToTopic({
          topic: "user-topic",
          title: createNotification.title,
          body: createNotification.body,
          data: {
            notificationid: notificationCode,
          },
        });
      }
      return notification;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async adminGetListNotification() {
    try {
      const listNotification = await this.prisma.notification.findMany();
      return listNotification;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async adminDetailNotification(notificationCode: string) {
    try {
      const detailNotification = await this.prisma.notification.findFirst({
        where: {
          notificationCode: notificationCode,
        },
      });
      return { ...detailNotification };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async adminUpdateNotification(
    notificationCode: string,
    updateNotification: UpdateNotificationDto,
  ) {
    try {
      const notification = await this.prisma.notification.update({
        where: {
          notificationCode: notificationCode,
        },
        data: {
          ...updateNotification,
        },
      });
      return notification;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async adminRemoveNotification(notificationCode: string) {
    try {
      const notification = await this.prisma.notification.update({
        where: {
          notificationCode: notificationCode,
        },
        data: {
          isActive: false,
        },
      });
      return notification;
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }

  async sendNotification(body: any) {
    try {
      console.log(`[===============> SENT NOTIF | `, body);
      const response = await this.firebaseService.sendNotification(
        body.token,
        body.title,
        body.body,
        body.data,
      );
      return { response };
    } catch (error) {
      throw new HttpException(error.message, 500);
    }
  }
}
