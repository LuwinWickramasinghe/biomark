import 'package:biomark/models/account_recovery_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../util/hash_password.dart';
import 'package:biomark/util/encryption_func.dart';
import 'package:biomark/util/string_helper.dart';

class Repository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> verifyUser(AccountRecoveryModel user) async {
    // Check in SQLite for existing hashed values
    // Assuming a function exists to verify locally (this part is not provided in the code)

    // If not found locally, check Firebase and store in SQLite
    final isVerified = await _verifyInFirebase(user);
    return isVerified;
  }

 Future<bool> _verifyInFirebase(AccountRecoveryModel user) async {
  try {
    // Encrypt the name and dob as they are stored in Firestore
    print(user.recoveryData);
   String encryptedName = encryptData(user.recoveryData['name'] ?? '');
   print(user.recoveryData['name']);
 // Use your encryption function
    String encryptedDob = encryptData(user.recoveryData['date_of_birth']?? ''); // Use your encryption function
print('here');
    // Hash the security question answers
    String hashedAnswer1 = hashPassword(user.recoveryData[user.recoveryData.keys.elementAt(2)]?? ''); // Replace index as needed
    String hashedAnswer2 = hashPassword(user.recoveryData[user.recoveryData.keys.elementAt(3)]?? ''); 
    
    print(hashedAnswer1);
    print(toCamelCase(user.recoveryData.keys.elementAt(3)));
    print(user.recoveryData[toCamelCase(user.recoveryData.keys.elementAt(2))]);
    print(toCamelCase(user.recoveryData.keys.elementAt(2)));// Replace index as needed

    // Query Firestore with the encrypted name, encrypted dob, and hashed answers
    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isEqualTo: encryptedName)
       // .where('dob', isEqualTo: encryptedDob)
      //  .where(user.recoveryData.keys.elementAt(2), isEqualTo: hashedAnswer1)
        .where(toCamelCase(user.recoveryData.keys.elementAt(3)), isEqualTo: hashedAnswer2)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // A document matching all fields was found
      return true;
    } else {
      // No document matches all provided data
      return false;
    }
  } catch (e) {
    // Catch any errors during Firestore verification
    print("Error during Firestore verification: $e");
    return false;
  }
}
Future<String?> getUserEmailFromFirebase(AccountRecoveryModel user) async {
  try {
    // Encrypt the name and dob as they are stored in Firestore
    String encryptedName = encryptData(user.recoveryData['name'] ?? '');
    String encryptedDob = encryptData(user.recoveryData['date_of_birth'] ?? ''); // Use your encryption function

    // Hash the security question answers
    String hashedAnswer1 = hashPassword(user.recoveryData[user.recoveryData.keys.elementAt(2)] ?? ''); // Replace index as needed
    String hashedAnswer2 = hashPassword(user.recoveryData[user.recoveryData.keys.elementAt(3)] ?? '');

    // Query Firestore with the encrypted name, encrypted dob, and hashed answers
    final querySnapshot = await _firestore
        .collection('users')
        .where('name', isEqualTo: encryptedName)
        //.where('dob', isEqualTo: encryptedDob)
        //.where(toCamelCase(user.recoveryData.keys.elementAt(2)), isEqualTo: hashedAnswer1)
        .where(toCamelCase(user.recoveryData.keys.elementAt(3)), isEqualTo: hashedAnswer2)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // A document matching all fields was found
      // Return the email of the first matching document
      return querySnapshot.docs.first['email'];
    } else {
      // No document matches all provided data
      return null;
    }
  } catch (e) {
    // Catch any errors during Firestore verification
    print("Error during Firestore verification: $e");
    return null;
  }
}


Future<String> updatePassword(String email, String newPassword) async {
  try {
    // Query Firestore to find the document that contains the email field
    var userQuery = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .limit(1) // Limit to 1 result, assuming emails are unique
        .get();

    if (userQuery.docs.isEmpty) {
      // If no document is found, return an error message
      return 'User not found';
    }

    // Retrieve the document ID from the query result
    String documentId = userQuery.docs.first.id;

    // Now update the password field of the found document
    await FirebaseFirestore.instance
        .collection('users')
        .doc(documentId) // Use the document ID
        .update({
          'password': hashPassword(newPassword), // Update the password field
        });

    return 'Password updated successfully';
  } catch (e) {
    return 'Error updating password: $e';
  }
}


}



