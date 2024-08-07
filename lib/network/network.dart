import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'model/User.dart';

const String baseUrl = "https://matchow-001-site1.ltempurl.com/";

//Auth
const String loginApi = "nam/Auth/Login";
const String profileApi = "nam/Auth/Profile";
const String updateProfileApi = "nam/Auth/Update";
const String checkLoginApi = "nam/Auth/Check";
const String registerEndPoint = "nam/Auth/Register";
const String verifyEmailEndPoint = "nam/Auth/VerifyCode";
const String usersApi = "nam/Auth/Users/";
const String readNotifyApi = "nam/Auth/ReadNotify";
const String logOutApi = "nam/Auth/LogOut";
const String forgetPassApi = "nam/Auth/ForgetPass";
const String reportUserApi = "nam/Auth/Report";
const String banUserApi = "nam/Auth/ChatBan";
const String deleteUserApi = "nam/Auth/Delete";

//Teams
const String teamsApi = "nam/Teams/Filter";
const String teamDetailApi = "nam/Teams/";
const String teamCreateApi = "nam/Teams/Create";
const String leftTeamApi = "nam/Teams/left";
const String deleteTeamApi = "nam/Teams";
const String joinTeamApi = "nam/Teams/join/";
const String acceptJoinApi = "nam/Teams/acJoin/";
const String rejectJoinApi = "nam/Teams/sgJoin/";
const String throwUserApi = "nam/Teams/throwUser/";
const String editTeamApi = "nam/Teams/Update";
const String swapCapitanApi = "nam/Teams/SwapCapitan";

//Games
const String gameCreateApi = "nam/Games/create";
const String gameCreateLinkApi = "nam/Games/createLink";
const String guideLinkApi = "nam/Games/Link";
const String getLinkGameApi = "nam/Games/getLinkGame";
const String getAllGameApi = "nam/Games/getAll";
const String getUnverfyGames = "nam/Games/UnVerify";
const String findPairApi = "nam/Games/FindPair";
const String getMyGamesApi = "nam/Games/getMyGames";
const String cancelGameApi = "nam/Games/CancelGame";
const String rejectGameApi = "nam/Games/Reject";
const String resultGameApi = "nam/Games/Result";
const String verifyGameApi = "nam/Games/Verify";
const String seeMoreApi = "nam/Games/SeeMore";
const String getVsGames = "nam/Games/Vs";
const String getGameDetails = "nam/Games/Detail";


//Division
const String allDivisionApi = "nam/Divisions/all";

//Blogs
const String getBlogsApi = "nam/Blogs/GetAll";
const String getBlogIdApi = "nam/Blogs/GetById";

//HomePage
const String getTopUsersApi = "nam/Anonymous/TopUsers";
const String getTopTeamsApi = "nam/Anonymous/TopTeams";

//Question
const String questionsApi = "nam/Anonymous/Questions";

//Suggestion
const String suggestionApi = "nam/Anonymous/Teklif";

Future<CheckUserExisting> checkExistenceOfUser(
    String email, String userName) async {
  var url = Uri.parse(baseUrl + checkLoginApi);
  var formData = {
    'Email': email,
    'UserName': userName,
  };
  var response = await http.post(
    url,
    body: formData,
  );

  if (response.statusCode == 200) {
    return CheckUserExisting(message: response.toString(), canSignUp: true);
  } else {
    return CheckUserExisting(message: response.toString(), canSignUp: false);
  }
}

Future<CheckUserExisting> registerUserApi(
    String name,
    String surname,
    String userName,
    String email,
    String password,
    File? profilePhoto,
    String phoneNumber,
    String dateTime) async {
  var url = Uri.parse(baseUrl + registerEndPoint);
  var formData = {
    'Name': name,
    'SurName': surname,
    'UserName': userName,
    'Email': email,
    'Password': password,
    'ProfilePhoto': profilePhoto == null ? "" : profilePhoto.toString(),
    'ProfilePhotoUrl': "",
    'PhoneNumber': "",
    'DateOfBirth': dateTime
  };
  var request = http.MultipartRequest('POST', url);
  if (profilePhoto != null) {
    request.files.add(http.MultipartFile(
      'ProfilePhoto',
      http.ByteStream(profilePhoto.openRead()),
      await profilePhoto.length(),
      filename:
          profilePhoto.path.split('/').last, // Set the desired filename here
    ));
  }
  formData.forEach((key, value) {
    request.fields[key] = value.toString();
  });
  http.Response response = await http.Response.fromStream(await request.send());

  if (response.statusCode == 200) {
    return CheckUserExisting(message: response.toString(), canSignUp: true);
  } else {

    return CheckUserExisting(message: jsonDecode(response.body)['message'], canSignUp: false);
    
  }
}
