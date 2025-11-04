const authQueries = {
   getUserAuth: "SELECT UserID, LevelCode, FullName, Email, PhoneNumber, PasswordHash, IsActive, _destroy FROM Users WHERE Email = ? or PhoneNumber = ?",
}

export default authQueries