import { useId, forwardRef } from 'react';

import Box from '@mui/material/Box';
import NoSsr from '@mui/material/NoSsr';
import { useTheme } from '@mui/material/styles';

import { RouterLink } from 'src/routes/components';

import { logoClasses } from './classes';

// ----------------------------------------------------------------------

export const Logo = forwardRef(
  ({ width = 100, height = 20, disableLink = false, className, href = '/', sx, ...other }, ref) => {
    const theme = useTheme();

    const gradientId = useId();
    const PRIMARY_LIGHT = theme.vars.palette.primary.light;

    const PRIMARY_MAIN = theme.vars.palette.primary.main;

    const PRIMARY_DARK = theme.vars.palette.primary.dark;
    console.log(`[===============> gradin | `, PRIMARY_LIGHT, PRIMARY_MAIN, PRIMARY_DARK);

    /*
     * OR using local (public folder)
     * const logo = ( <Box alt="logo" component="img" src={`${CONFIG.site.basePath}/logo/logo-single.svg`} width={width} height={height} /> );
     */

    const logo = (
      // <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 512 512">
      //   <defs>
      //     <linearGradient id={`${gradientId}-1`} x1="100%" x2="50%" y1="9.946%" y2="50%">
      //       <stop offset="0%" stopColor={PRIMARY_DARK} />
      //       <stop offset="100%" stopColor={PRIMARY_MAIN} />
      //     </linearGradient>

      //     <linearGradient id={`${gradientId}-2`} x1="50%" x2="50%" y1="0%" y2="100%">
      //       <stop offset="0%" stopColor={PRIMARY_LIGHT} />
      //       <stop offset="100%" stopColor={PRIMARY_MAIN} />
      //     </linearGradient>

      //     <linearGradient id={`${gradientId}-3`} x1="50%" x2="50%" y1="0%" y2="100%">
      //       <stop offset="0%" stopColor={PRIMARY_LIGHT} />
      //       <stop offset="100%" stopColor={PRIMARY_MAIN} />
      //     </linearGradient>
      //   </defs>

      //   <g fill={PRIMARY_MAIN} fillRule="evenodd" stroke="none" strokeWidth="1">
      //     <path
      //       fill={`url(#${`${gradientId}-1`})`}
      //       d="M183.168 285.573l-2.918 5.298-2.973 5.363-2.846 5.095-2.274 4.043-2.186 3.857-2.506 4.383-1.6 2.774-2.294 3.939-1.099 1.869-1.416 2.388-1.025 1.713-1.317 2.18-.95 1.558-1.514 2.447-.866 1.38-.833 1.312-.802 1.246-.77 1.18-.739 1.111-.935 1.38-.664.956-.425.6-.41.572-.59.8-.376.497-.537.69-.171.214c-10.76 13.37-22.496 23.493-36.93 29.334-30.346 14.262-68.07 14.929-97.202-2.704l72.347-124.682 2.8-1.72c49.257-29.326 73.08 1.117 94.02 40.927z"
      //     />
      //     <path
      //       fill={`url(#${`${gradientId}-2`})`}
      //       d="M444.31 229.726c-46.27-80.956-94.1-157.228-149.043-45.344-7.516 14.384-12.995 42.337-25.267 42.337v-.142c-12.272 0-17.75-27.953-25.265-42.337C189.79 72.356 141.96 148.628 95.69 229.584c-3.483 6.106-6.828 11.932-9.69 16.996 106.038-67.127 97.11 135.667 184 137.278V384c86.891-1.611 77.962-204.405 184-137.28-2.86-5.062-6.206-10.888-9.69-16.994"
      //     />
      //     <path
      //       fill={`url(#${`${gradientId}-3`})`}
      //       d="M450 384c26.509 0 48-21.491 48-48s-21.491-48-48-48-48 21.491-48 48 21.491 48 48 48"
      //     />
      //   </g>
      // </svg>

      <svg
        xmlns="http://www.w3.org/2000/svg"
        viewBox="-38.601 111.6455 438.1602 84.67"
        width="100%"
        height="auto"
        // width="100%" height="100%"
        // preserveAspectRatio="none"
      >
        <defs>
          <linearGradient id={`${gradientId}-1`} x1="0%" y1="0%" x2="100%" y2="100%">
            <stop offset="0" stopColor={PRIMARY_LIGHT} />
            <stop offset="0.3" stopColor={PRIMARY_MAIN} />
            <stop offset="0.7" stopColor={PRIMARY_DARK} />
            <stop offset="1" stopColor={PRIMARY_LIGHT} />


          </linearGradient>
        </defs>
        <g id="object-0" transform="matrix(1, 0, 0, 1, 0, 1.4210854715202004e-14)">
          <path
            fill={`url(#${`${gradientId}-1`})`}
            d="M 113.749 126.636 L 113.749 111.646 L 69.739 111.646 C 69.739 111.646 67.019 111.646 67.019 111.646 L 50.619 111.646 L 25.049 168.926 C 24.399 170.546 22.789 171.516 20.949 171.516 L 7.469 171.516 C 5.739 171.516 4.129 170.546 3.369 168.926 L -22.201 111.646 L -38.601 111.646 L -9.911 175.936 C -7.001 182.296 -0.631 186.506 6.379 186.506 L 22.019 186.506 C 29.029 186.506 35.399 182.296 38.309 175.936 L 60.309 126.636 L 72.919 126.636 C 72.919 126.636 83.429 126.636 83.429 126.636 L 83.429 171.506 L 69.729 171.506 L 69.729 186.496 L 113.739 186.496 L 113.739 171.506 L 100.149 171.506 L 100.149 126.636 L 113.739 126.636 L 113.749 126.636 Z"
            // style="stroke-width: 1; paint-order: fill;"
          />
          <g fill={`url(#${`${gradientId}-1`})`} transform="matrix(1, 0, 0, 1, -69.520859, -96.024467)">
            <path
              d="M467.03,257.5c1.29-3.88,2.05-8.09,2.05-12.4,0-21.14-17.15-37.43-38.29-37.43h-205.04c-21.25,0-38.4,16.29-38.4,37.43s17.15,37.43,38.4,37.43h42.23c8.28,0,14.99-6.71,14.99-14.99h-57.22c-2.5,0-5-.46-7.33-1.38-3.73-1.47-6.96-4.08-9.25-7.37-2.75-3.95-4.05-8.64-4.05-13.44,0-2.78.32-5.6,1.19-8.25.92-2.79,2.39-5.4,4.34-7.6,1.87-2.12,4.18-3.85,6.76-5.03,2.61-1.2,5.47-1.81,8.34-1.81,0,0,86.45-.11,86.45-.11v60.09h16.72v-60.09h33.46c-4.78,6.22-7.63,13.97-7.63,22.55,0,21.14,17.15,37.43,38.4,37.43h27.51c3.34,0,6.47,1.19,8.85,3.34l7.44,6.47h25.46l-28.37-24.81h-40.88c-11.43,0-20.71-9.49-20.71-22.44s9.28-22.44,20.71-22.44h37.65c11.43,0,20.6,9.49,20.6,22.44,0,4.64-1.19,8.84-3.24,12.4h18.88Z"
              // style="paint-order: fill;"
            />
            <path
              d="M221.93,245.5h0c0,4.14,3.36,7.5,7.5,7.5h25.42v-14.99h-25.42c-4.14,0-7.5,3.36-7.5,7.5Z"
              // style="paint-order: fill;"
            />
          </g>
        </g>
      </svg>

      //       <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 500 500" width="100%" height="100%">
      //   <defs>
      //     <linearGradient id="gradient-1" x1="0%" y1="0%" x2="100%" y2="100%">
      //        <stop offset="0%" stopColor={PRIMARY_LIGHT} />
      //         <stop offset="100%" stopColor={PRIMARY_MAIN} />
      //     </linearGradient>
      //   </defs>

      //   <path fill="url(#gradient-1)" d="M183.27,222.66v-14.99h-44.01s-2.72,0-2.72,0h-16.4l-25.57,57.28c-.65,1.62-2.26,2.59-4.1,2.59h-13.48c-1.73,0-3.34-.97-4.1-2.59l-25.57-57.28h-16.4l28.69,64.29c2.91,6.36,9.28,10.57,16.29,10.57h15.64c7.01,0,13.38-4.21,16.29-10.57l22-49.3h12.61s10.51,0,10.51,0v44.87h-13.7v14.99h44.01v-14.99h-13.59v-44.87h13.59Z" />

      //   <g fill="url(#gradient-1)">
      //     <path d="M467.03,257.5c1.29-3.88,2.05-8.09,2.05-12.4,0-21.14-17.15-37.43-38.29-37.43h-205.04c-21.25,0-38.4,16.29-38.4,37.43s17.15,37.43,38.4,37.43h42.23c8.28,0,14.99-6.71,14.99-14.99h-57.22c-2.5,0-5-.46-7.33-1.38-3.73-1.47-6.96-4.08-9.25-7.37-2.75-3.95-4.05-8.64-4.05-13.44,0-2.78.32-5.6,1.19-8.25.92-2.79,2.39-5.4,4.34-7.6,1.87-2.12,4.18-3.85,6.76-5.03,2.61-1.2,5.47-1.81,8.34-1.81,0,0,86.45-.11,86.45-.11v60.09h16.72v-60.09h33.46c-4.78,6.22-7.63,13.97-7.63,22.55,0,21.14,17.15,37.43,38.4,37.43h27.51c3.34,0,6.47,1.19,8.85,3.34l7.44,6.47h25.46l-28.37-24.81h-40.88c-11.43,0-20.71-9.49-20.71-22.44s9.28-22.44,20.71-22.44h37.65c11.43,0,20.6,9.49,20.6,22.44,0,4.64-1.19,8.84-3.24,12.4h18.88Z"/>
      //     <path d="M221.93,245.5h0c0,4.14,3.36,7.5,7.5,7.5h25.42v-14.99h-25.42c-4.14,0-7.5,3.36-7.5,7.5Z"/>
      //   </g>
      // </svg>
    );

    return (
      <NoSsr
        fallback={
          <Box
            width={width}
            height={height}
            className={logoClasses.root.concat(className ? ` ${className}` : '')}
            sx={{
              flexShrink: 0,
              display: 'inline-flex',
              verticalAlign: 'middle',
              ...sx,
            }}
          />
        }
      >
        <Box
          ref={ref}
          component={RouterLink}
          href={href}
          width={width}
          height={height}
          className={logoClasses.root.concat(className ? ` ${className}` : '')}
          aria-label="logo"
          sx={{
            flexShrink: 0,
            display: 'inline-flex',
            verticalAlign: 'middle',
            ...(disableLink && { pointerEvents: 'none' }),
            ...sx,
          }}
          {...other}
        >
          {/* <Box
            component="img"
            sx={{
              // height: 30,
              objectFit: 'cover',
              maxHeight: { xs: 233, md: 167 },
              maxWidth: { xs: 350, md: 250 },
            }}
            alt="The house from the offer."
            src="/assets/images/logo/logo.png"
          /> */}
          {logo}
        </Box>
      </NoSsr>
    );
  }
);
