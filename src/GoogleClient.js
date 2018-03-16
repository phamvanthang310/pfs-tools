import GoogleTranslate from 'google-translate';
import { default as logger } from './utils/logger';

export default class GoogleClient {
  constructor(targetLanguage = 'zh') {
    this.translator = GoogleTranslate('AIzaSyDWNvub5X6qVwk8VBqKyvurHGskLGMIJPc');
    this.targetLanguage = targetLanguage;
  }

  translate(text) {
    this.translator.translate(text, this.targetLanguage, (err, result) => {
      if (err) logger.error(err);
      console.dir(result);
    });
  }
}
