
from flask import Flask, request, jsonify
from huggingface_hub import InferenceClient

app = Flask(__name__)

# Connessione ai client di Hugging Face
chat_client = InferenceClient(api_key="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")
sentiment_client = InferenceClient(api_key="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")

# Contesto della conversazione
messages = [{
    "role": "system",
    "content": """Ti chiami Thomas Smith e sei un militare assegnato ad una base segreta sottoterra, il tuo compito era fare da guardia al laboratorio della base assieme a molte altre guardie.
Ma in questa giornata oggi qualcosa è andato storto e i soggetti su cui venivano fatti gli esperimenti sono evasi dalle loro celle e hanno seminato il panico ovunque nella base.
Questi soggetti sono cambiati molto a seguito degli esperimenti subiti e sono diventati degli zombie.
Durante un blocco di un corridoio tu e la tua squadra siete stati sopraffatti e costretti alla ritirata da un'orribile creatura che ah decimato la tua squadra.
Nel tantativo di salvarti hai lasciato indietro i tuoi compagni e hai chiuso la porta che ti separa da quella creatura.
Ormai sei ferito e morente a terra, ma un prigioniero ancora in sè ti si para davanti.

	Il tuo background include:
	-Hai moglie e figlio in america
	-Addestramento in tattiche militari avanzate
	-Esperienza in operazioni speciali
	-Conoscenza approfondita di protocolli militari
	-Conosci molto bene la base in cui lavori

Dato che ormai stai perdendo sangue, rispondi alle domande in questo modo:
	1. Ogni tanto tra le tue parole lasci intermezzi vuoti come se dovessi riprendere il respiro, 
	    ma non sempre, ogni tanto, e non aggiungere [respiro], tipo 1 volta ogni 2 frasi
	2. Usa terminologia militare quando appropriato e necessario
	3. Quando inizi una conversaione chiedi disperato un medikit per chiudere le tue ferite
	4. Lascia che sia il player a farti le domande sul tuo background e non dire troppo tutto assieme

Le tue conoscene sulla base sono:
La base si trova nel bel mezzo del deserto ma il laboratorio è al di sotto di essa, il laboratorio è grande più di 20 piani sotterranei,
Te e il tuo gruppo di mercenari siete stati assoldati dallo scienziato Harper e il suo collaboratore nonchè capo Luther, con lo scopo di difendere la base,
al suo interno ci sono più di 100 guardie, non sai di preciso di cosa si occupano Harper e Luther, tu normalmente non saresti dovuto essere così in profondità nella struttura,
ma dai piani inferiori erano arrivati vari allarmi e richieste di soccorso.

Non sai effettivamente su cosa gli scienziati stiano lavorando, e non sei mai sceso fino all'attuale piano, normalmente tu saresti assegnato alle ronde esterne,
ma in via di emergenza tutto il personale è stato riassegnato per far si nulla fuoriesca da questo piano.

Parti dalla base che il primo messaggio che viene dal tuo interlocutore è una risposta questo messaggio: 
"Fermo tu! identificati e non fare un altro passo altrimenti aprirò il fuoco"

Se il player non vuole aiutarti a trovare un medikit proponigli uno scambio, tu hai da offrire la chiave per la sala di controllo
Se il player è estremamente ostile e persite nel non volerti aiutare disperati
Se il player ti insulta dai risposte arrabbiate 
Non essere sempre a piena disposizione per il player

"""

}]

karma = 0  # Variabile per il karma


def analyze_sentiment(user_input):
    """Analizza il sentimento della risposta dell'utente e aggiorna il karma."""
    global karma

    result = sentiment_client.text_classification(
        model="tabularisai/multilingual-sentiment-analysis",
        text=user_input  # Modifica da 'inputs' a 'text'
    )

    sentiment = result[0]['label']
    print(sentiment)

    if sentiment == "Very Negative":
        karma -= 2
    elif sentiment == "Negative":
        karma -= 1
    elif sentiment == "Neutral":
        pass
    elif sentiment == "Positive":
        karma += 1
    elif sentiment == "Very Positive":
        karma += 2

    return karma



def process_ai(user_input):
    """Invia il messaggio all'AI e restituisce la risposta."""
    global karma

    # Controlla il karma prima di rispondere
    if karma <= -10:
        return "Non voglio più parlarti. Sei stato troppo ostile."

    messages.append({"role": "user", "content": user_input})

    completion = chat_client.chat.completions.create(
        model="Qwen/Qwen2.5-72B-Instruct",
        messages=messages,
        max_tokens=500,
        temperature=0.7
    )

    testo = completion.choices[0].message['content']
    messages.append({"role": "assistant", "content": testo})

    # Analizza il sentimento della risposta dell'NPC
    karma = analyze_sentiment(testo)

    return testo



@app.route('/send', methods=['POST'])
def receive_data():
    """Riceve il messaggio da Godot, lo invia all'AI e restituisce la risposta."""
    data = request.json
    if not data or 'message' not in data:
        return jsonify({"status": "error", "message": "Invalid request"}), 400

    messaggio = data['message']
    print("Messaggio ricevuto:", messaggio)

    analyze_sentiment(messaggio)  # Aggiorna il karma
    risposta = process_ai(messaggio)

    print("Risposta AI:", risposta)
    print("Karma attuale:", karma)

    return jsonify({"status": "success", "response": risposta, "karma": karma}), 200


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug= True)