# CRC cards

---

- CRC cards stands for **class responsibility collaborator** cards
- its a way to model classes of a program and map interactions between classes
- draw up quick CRC cards as part of your brainstorming session

![CRC card example](https://d1b1wr57ag5rdp.cloudfront.net/images/oop/lesson2/crc_card_components_2.jpg)

- the components of a CRC card

![CRC card - Human class](https://d1b1wr57ag5rdp.cloudfront.net/images/oop/lesson2/human_crc_card.png)

- an example of the `human` class CRC card

![CRC model](https://d1b1wr57ag5rdp.cloudfront.net/images/oop/lesson2/crc_model.png)

- all the CRC cards for the RPS game classes

![CRC card - RPSGame class](https://d1b1wr57ag5rdp.cloudfront.net/images/oop/lesson2/rpsgame_crc_card.png)

- the `RPSGame` class CRC card

- **note:** we don't want to list all the methods in the RPS game class only the public methods that can or should be called from outside the class
- Methods like `display_welcome_message` is used internally by the `play` method, and is more of an implementation detail.

**In general, you should follow the below approach:**

1. Write a description of the problem and extract major nouns and verbs.
2. Make an initial guess at organizing the verbs and nouns into methods and classes/modules, then do a spike to explore the problem with temporary code.
3. When you have a better idea of the problem, model your thoughts into CRC cards.