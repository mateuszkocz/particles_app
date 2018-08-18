import './main.sass'
import { Main } from './Main.elm'
import registerServiceWorker from './registerServiceWorker'

Main.embed(
  document.getElementById('root'),
  {
    apiPath: process.env.ELM_APP_API_PATH
  }
)

registerServiceWorker()
