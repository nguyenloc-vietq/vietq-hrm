import { Controller, useFormContext } from 'react-hook-form';

import { PhoneInput } from '../phone-input';

// ----------------------------------------------------------------------

export function RHFPhoneInput({ name, helperText, enabled = true, ...other }) {
  const { control, setValue } = useFormContext();
  console.log(control, setValue);

  return (
    <Controller
      name={name}
      control={control}
      render={({ field, fieldState: { error } }) => (
        <PhoneInput
          {...field}
          enabled={enabled}
          fullWidth
          value={field.value}
          onChange={(newValue) => setValue(name, newValue, { shouldValidate: true })}
          error={!!error}
          helperText={error ? error?.message : helperText}
          {...other}
        />
      )}
    />
  );
}
