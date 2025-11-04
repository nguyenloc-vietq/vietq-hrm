import  express  from 'express';
import authControllelr from '../controllers/auth.controller';


const router = express.Router();

// 
router.post("/login", authControllelr.login);
export default router;