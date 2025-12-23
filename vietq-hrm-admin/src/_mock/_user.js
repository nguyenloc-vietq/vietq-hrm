import { _mock } from './_mock';

// ----------------------------------------------------------------------

export const ACTIVE_STATUS_OPTION = [
  { value: 'Y', label: 'Active' },
  { value: 'N', label: 'Banned' },
];

export const _userAbout = {
  id: _mock.id(1),
  role: _mock.role(1),
  email: _mock.email(1),
  school: _mock.companyNames(2),
  company: _mock.companyNames(1),
  country: _mock.countryNames(2),
  coverUrl: _mock.image.cover(3),
  totalFollowers: _mock.number.nativeL(1),
  totalFollowing: _mock.number.nativeL(2),
  quote:
    'Tart I love sugar plum I love oat cake. Sweet roll caramels I love jujubes. Topping cake wafer..',
  socialLinks: {
    facebook: `https://www.facebook.com/caitlyn.kerluke`,
    instagram: `https://www.instagram.com/caitlyn.kerluke`,
    linkedin: `https://www.linkedin.com/in/caitlyn.kerluke`,
    twitter: `https://www.twitter.com/caitlyn.kerluke`,
  },
};

export const _userFollowers = [...Array(18)].map((_, index) => ({
  id: _mock.id(index),
  name: _mock.fullName(index),
  country: _mock.countryNames(index),
  avatarUrl: _mock.image.avatar(index),
}));

export const _userFriends = [...Array(18)].map((_, index) => ({
  id: _mock.id(index),
  role: _mock.role(index),
  name: _mock.fullName(index),
  avatarUrl: _mock.image.avatar(index),
}));

export const _userGallery = [...Array(12)].map((_, index) => ({
  id: _mock.id(index),
  postedAt: _mock.time(index),
  title: _mock.postTitle(index),
  imageUrl: _mock.image.cover(index),
}));

export const _userFeeds = [...Array(3)].map((_, index) => ({
  id: _mock.id(index),
  createdAt: _mock.time(index),
  media: _mock.image.travel(index + 1),
  message: _mock.sentence(index),
  personLikes: [...Array(20)].map((__, personIndex) => ({
    name: _mock.fullName(personIndex),
    avatarUrl: _mock.image.avatar(personIndex + 2),
  })),
  comments: (index === 2 && []) || [
    {
      id: _mock.id(7),
      author: {
        id: _mock.id(8),
        avatarUrl: _mock.image.avatar(index + 5),
        name: _mock.fullName(index + 5),
      },
      createdAt: _mock.time(2),
      message: 'Praesent venenatis metus at',
    },
    {
      id: _mock.id(9),
      author: {
        id: _mock.id(10),
        avatarUrl: _mock.image.avatar(index + 6),
        name: _mock.fullName(index + 6),
      },
      createdAt: _mock.time(3),
      message:
        'Etiam rhoncus. Nullam vel sem. Pellentesque libero tortor, tincidunt et, tincidunt eget, semper nec, quam. Sed lectus.',
    },
  ],
}));

export const _userCards = [...Array(21)].map((_, index) => ({
  id: _mock.id(index),
  role: _mock.role(index),
  name: _mock.fullName(index),
  coverUrl: _mock.image.cover(index),
  avatarUrl: _mock.image.avatar(index),
  totalFollowers: _mock.number.nativeL(index),
  totalPosts: _mock.number.nativeL(index + 2),
  totalFollowing: _mock.number.nativeL(index + 1),
}));

export const _userPayment = [...Array(3)].map((_, index) => ({
  id: _mock.id(index),
  cardNumber: ['**** **** **** 1234', '**** **** **** 5678', '**** **** **** 7878'][index],
  cardType: ['mastercard', 'visa', 'visa'][index],
  primary: index === 1,
}));

export const _userAddressBook = [...Array(4)].map((_, index) => ({
  id: _mock.id(index),
  primary: index === 0,
  name: _mock.fullName(index),
  phoneNumber: _mock.phoneNumber(index),
  fullAddress: _mock.fullAddress(index),
  addressType: (index === 0 && 'Home') || 'Office',
}));

export const _userInvoices = [...Array(10)].map((_, index) => ({
  id: _mock.id(index),
  invoiceNumber: `INV-199${index}`,
  createdAt: _mock.time(index),
  price: _mock.number.price(index),
}));

export const _userPlans = [
  { subscription: 'basic', price: 0, primary: false },
  { subscription: 'starter', price: 4.99, primary: true },
  { subscription: 'premium', price: 9.99, primary: false },
];

export const _userList = [
  {
    id: 14,
    companyCode: 'CPA000001',
    userCode: 'USR000002',
    email: 'ngo.hoang.giang@viet-q.com',
    phone: '+84334644324',
    fullName: 'Ngo Hoang Giang',
    address: null,
    avatar: 'avatar/avatar-1764147500177-306563168.png',
    isActive: 'Y',
    createdAt: '2025-11-24T08:40:53.216Z',
    updatedAt: '2025-11-26T08:58:20.189Z',
    professionals: {
      0: {
        position: 'Software Engineer',
        employeeType: 'Full Time',
        companyCode: 'CPA000001',
      },
    },
  },
  {
    id: 16,
    companyCode: 'CPA000001',
    userCode: 'USR000003',
    email: 'tran.vu@viet-q.com',
    phone: '+84769763217',
    fullName: 'Tran The Vu',
    address: null,
    avatar: 'avatar/avatar-1764148097849-522213556.png',
    isActive: 'Y',
    createdAt: '2025-11-24T08:42:43.941Z',
    updatedAt: '2025-11-26T09:08:17.861Z',
    professionals: {
      0: {
        position: 'Software Engineer',
        employeeType: 'Full Time',
        companyCode: 'CPA000001',
      },
    },
  },
  {
    id: 17,
    companyCode: 'CPA000001',
    userCode: 'USR000004',
    email: 'designvq@viet-q.com',
    phone: '+84969946775',
    fullName: 'Ngan Nguyen',
    address: null,
    avatar: 'avatar/avatar-1764147679370-406323486.png',
    isActive: 'Y',
    createdAt: '2025-11-24T08:46:11.911Z',
    updatedAt: '2025-11-26T09:01:19.373Z',
    professionals: {
      0: {
        position: 'UI/UX - Graphic Designer',
        employeeType: 'Full Time',
        companyCode: 'CPA000001',
      },
    },
  },
  {
    id: 18,
    companyCode: 'CPA000001',
    userCode: 'USR000005',
    email: 'duy.huu@viet-q.com',
    phone: '+84776902759',
    fullName: 'Tran Duy Huu',
    address: null,
    avatar: null,
    isActive: 'Y',
    createdAt: '2025-11-24T08:48:09.335Z',
    updatedAt: '2025-11-24T08:48:09.335Z',
    professionals: {
      0: {
        position: 'Head Of Office',
        employeeType: 'Full Time',
        companyCode: 'CPA000001',
      },
    },
  },
];
