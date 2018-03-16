import GoogleTranslate from 'google-translate';

export default class GoogleClient {
  constructor(targetLanguage = 'zh') {
    this.translator = GoogleTranslate('AIzaSyDWNvub5X6qVwk8VBqKyvurHGskLGMIJPc');
    this.targetLanguage = targetLanguage;
  }

  translate(text) {
    return new Promise(((resolve, reject) => {
      this.translator.translate(text, this.targetLanguage, (err, result) => {
        if (err) reject(err);
        resolve(result);
      });
    }));
  }
}
