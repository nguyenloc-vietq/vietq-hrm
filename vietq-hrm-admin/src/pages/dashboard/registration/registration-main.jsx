import { Helmet } from 'react-helmet-async';

import { CONFIG } from 'src/config-global';

import { RegistrationMain } from 'src/sections/registration/view';

const metadata = { title: `Registration | Dashboard - ${CONFIG.site.name}` };

export default function Page() {
  return (
    <>
      <Helmet>
        <title> {metadata.title}</title>
      </Helmet>
      <RegistrationMain />
    </>
  );
}
