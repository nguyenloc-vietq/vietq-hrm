import React from 'react';
import dayjs from 'dayjs';

import { LoadingButton } from '@mui/lab';
import { DatePicker } from '@mui/x-date-pickers';
import { Box, Button, Dialog, DialogTitle, DialogActions, DialogContent } from '@mui/material';

function CreateReportForm({ open, handleClose }) {
  const [selectedDate, setSelectedDate] = React.useState(null);

  return (
    <Dialog fullWidth maxWidth="sm" open={open} onClose={handleClose}>
      <DialogTitle>Create Report</DialogTitle>
      <DialogContent>
        <Box sx={{ pt: 1, pb: 1 }}>
          <DatePicker
            label="Select Date"
            views={['month']}
            openTo="year"
            value={dayjs()}
            onChange={(newValue) => setSelectedDate(newValue)}
          />
        </Box>
      </DialogContent>
      <DialogActions>
        <Button variant="outlined" onClick={handleClose}>
          Cancel
        </Button>

        <LoadingButton
          type="submit"
          variant="contained"
          loading={false}
          // disabled={}
        >
          Create report
        </LoadingButton>
      </DialogActions>
    </Dialog>
  );
}

export default CreateReportForm;
