class NetworkConstants {
  String get baseUrl => "";

  ///ApI to get the [random memes] from the reddit server
  String get getRandomMemeUrl => "https://www.reddit.com/r/memes.json";

  ///API to get [random images] from the imgflip server to generate your own meme
  String get memeGeneratorImageUrl => "http://api.imgflip.com/get_memes";
}
