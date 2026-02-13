from enum import StrEnum
import numpy as np
import matplotlib.pyplot as plt
from keras._tf_keras.keras import utils
from keras.src.layers import BatchNormalization, Dense, Dropout, SpatialDropout1D, Embedding, Flatten
from keras.src.models import Sequential
from keras_preprocessing.text import Tokenizer
from sklearn.metrics import confusion_matrix, ConfusionMatrixDisplay
import gdown
import os
import time
import re
import pickle
import zipfile
import matplotlib.pyplot as plt
plt.style.use('ggplot')


FILE_TEST = './writers/(Булгаков) Обучающая_5 вместе.txt'

menu = \
  """
  1. Скачать данные
  2. Показать данные
  3. ЧАСТЬ 1 - Преобразование текста из последовательного набора слов в последовательный набор чисел
  4. ЧАСТЬ 2 - Токенизатор Keras и техника преобразования текста в числовые и векторные представления
  5. ЧАСТЬ 3 - Преобразование текстовых данных в числовые и векторные представления для обучения нейросети
  6. ЧАСТЬ 4 (1) - Способ обучения BagOfWords
  7. ЧАСТЬ 4 (2) - Способ обучения Embedding + Dense: размерность эмбеддингов 20
  8. ЧАСТЬ 4 (3) - Способ обучения Embedding + Dense: размерность эмбеддингов 200
  9. ЧАСТЬ 4 (4) - Способ обучения Embedding + Dense: размерность эмбеддингов 200 без слоев регуляризации SpatialDropout1D, Droupout
  
  0. Выход
  
  Выберите пункт меню: 
  """
  
  
MAX_WORDS_COUNT = 20000                       
WIN_SIZE   = 1000                        
WIN_HOP    = 100

PART1_COMPLETE = False
PART2_COMPLETE = False
PART3_COMPLETE = False


# start prepare
text = FILE_TEST
re.findall(r'((?<=[(])\w.+(?=[)]))', text)

lst = []
for i in os.listdir('writers'):
  lst.append(re.findall(r'((?<=[(])[А-я].+(?=[)]))', i)[0])

writers = sorted(list(set(lst)))
ClassCount = len(writers)
# end prepare

class timex:
  def __enter__(self):
    self.t = time.time()
    return self

  def __exit__(self, type, value, traceback):
    print('\033[91mВремя обработки: {:.2f} с\033[0m'.format(time.time() - self.t))


def readText(fileName):
  with open(fileName, 'r') as f:
    text = f.read()
    text = text.replace('\n', ' ')

  return text 


def download():
  url = 'https://storage.yandexcloud.net/aiueducation/Content/base/l7/writers.zip'
  output = 'writers.zip'

  gdown.download(url, output, quiet=True)

  with zipfile.ZipFile(output, 'r') as zip_ref:
    zip_ref.extractall('writers')

  os.remove(output)
  print("Файл успешно загружен и распакован!")


def showText():
  text_1 = readText(FILE_TEST)
  print(text_1[:500])


def part1():
  global train_text, test_text, PART1_COMPLETE
  
  for name in os.listdir('writers'):
    print(name)

  for name in os.listdir('writers'):
    if writers[0] in name:
      print(name)

  train_text = []
  test_text = []

  count_test = 0
  count_train = 0

  for name in writers:
    for path in os.listdir('writers'):
      if name in path:
        if 'Обучающая' in path:
          print(f'Обучающая добавлена для {name}[{count_train}]')
          train_text.append(readText(f'writers/{path}'))
          count_train += 1

        else:
          print(f'Тестовая добавлена для {name}[{count_test}]')
          test_text.append(readText(f'writers/{path}'))
          count_test += 1

    print('-'*100)

  print('>>', writers[0])
  print('>>', train_text[0][:100])

  print('\nПроверка загрузки: вывод начальных отрывков из каждого класса:')
  for cls in range(ClassCount):
      print(f'Класс: {writers[cls]}[{cls}]')
      print(f'  train: {train_text[cls][:200]}')
      print(f'  test : {test_text[cls][:200]}')
      print()

  # Создаем bar-график с разными цветами для каждого столбца
  color_lst = [0.05 , 0.1, 0.2, 0.3, 0.4, 0.5 ]
  colors = plt.cm.viridis(color_lst)

  color_lst2 = [0.6, 0.68, 0.72, 0.85, 0.95, 1. ]
  colors2 = plt.cm.viridis(color_lst2)

  text_lengths = list(map(len, train_text))

  plt.figure(figsize=(15, 5))

  plt.subplot(1, 2, 1) 
  plt.bar(writers, text_lengths, color=colors)
  for i, count in enumerate(text_lengths):
      plt.text(i, count - 200000, str(count), ha='center', color='white', fontweight='bold')
  plt.xticks(rotation=45, ha='right', color=colors[1])
  plt.xlabel('Писатели', color='m')
  plt.ylabel('Длина текста', color='b')
  plt.title('Длина текста для каждого писателя', color=colors[0])

  plt.subplot(1, 2, 2) 
  plt.pie(text_lengths, labels=writers, colors=colors2, autopct='%1.1f%%', startangle=90, counterclock=False)
  plt.title('Распределение текстов по писателям', color=colors[0])

  plt.tight_layout()

  plt.show()
  
  PART1_COMPLETE = True
  
  
def part2():
  global PART1_COMPLETE, PART2_COMPLETE
  
  if not PART1_COMPLETE:
    print("\nСначала выполните ЧАСТЬ 1")
    return
    
  sample_text = ['один два две двум двум двум три четыре пять два Три три четыре четыре четыре пять пять пять пять шесть семь восемь']

  tokenizer = Tokenizer(num_words=5, filters='!"#$%&()*+,-–—./…:;<=>?@[\\]^_`{|}~«»\t\n\xa0\ufeff', lower=True, split=' ', oov_token='неизвестное_слово', char_level=False)
  tokenizer.fit_on_texts(sample_text)

  with open('tokenizer.pickle', 'wb') as f:
      pickle.dump(tokenizer, f)

  print(len(sample_text[0].split()))

  print(tokenizer.word_index)

  print(list(tokenizer.word_index.items()))

  sample_text = ['один трем два три четыре пять два два Три три четыре четыре четыре пять пять пять пять шесть семь восемь']

  sample_seq = tokenizer.texts_to_sequences(sample_text)
  print(sample_seq)
  print(len(sample_seq[0]))

  x_train = [sample_seq[0][i:i + 3] for i in range(0, len(sample_seq[0]), 3)]

  print(x_train)
  print(tokenizer.sequences_to_matrix(x_train))
  
  PART2_COMPLETE = True
  
  
def part3():
  global x_train, y_train, x_test, y_test, x_train_01, x_test_01, PART1_COMPLETE, PART2_COMPLETE, PART3_COMPLETE
  
  if not PART1_COMPLETE:
    print("\nСначала выполните ЧАСТЬ 1")
    return
  
  if not PART2_COMPLETE:
    print("\nСначала выполните ЧАСТЬ 2")
    return

  # Токенизация и построение частотного словаря по обучающим текстам
  with timex():
      # Используется встроенный в Keras токенизатор для разбиения текста и построения частотного словаря
      tokenizer = Tokenizer(num_words=MAX_WORDS_COUNT, filters='!"#$%&()*+,-–—./…:;<=>?@[\\]^_`{|}~«»\t\n\xa0\ufeff',
                            lower=True, split=' ', oov_token='неизвестное_слово', char_level=False)

      # Использованы параметры:
      # num_words   - объем словаря
      # filters     - убираемые из текста ненужные символы
      # lower       - приведение слов к нижнему регистру
      # split       - разделитель слов
      # char_level  - указание разделять по словам, а не по единичным символам
      # oov_token   - токен для слов, которые не вошли в словарь
    
      # Построение частотного словаря по обучающим текстам
      tokenizer.fit_on_texts(train_text)

      # Построение словаря в виде пар слово - индекс
      items = list(tokenizer.word_index.items())

  print('\nВывод нескольких наиболее часто встречающихся слов:')
  print(items[:120])

  print("\nРазмер словаря", len(items))
  print(items[10000:10120])

  species = ('TEXT')
  sex_counts = {
      'MAX_WORDS_COUNT': np.array([20_000]),
      'TOTAL': np.array([133_070]),
  }
  width = 0.6

  fig, ax = plt.subplots(figsize=(2, 6))
  bottom = np.zeros(3)

  colors = {'MAX_WORDS_COUNT': '#ff9933', 'TOTAL': '#0099cc'}

  for sex, sex_count in sex_counts.items():
      p = ax.bar(species, sex_count, width, label=sex, bottom=bottom, color=colors.get(sex, 'gray'))
      bottom += sex_count
      ax.bar_label(p, label_type='center', color='black')

  ax.set_title('Корпус текста')

  plt.show()

  # Проверка индекса слова в словаре
  try:
      print('Интересующее слово имеет индекс:', tokenizer.word_index[input('Введите слово: ')])
  except:
      print('Интересующего вас слова нет в словаре')

  # Преобразование обучающих и проверочных текстов в последовательность индексов согласно частотному словарю
  with timex():
      seq_train = tokenizer.texts_to_sequences(train_text)
      seq_test = tokenizer.texts_to_sequences(test_text)

  print('\nПреобразование обучающих и проверочных текстов в последовательность индексов согласно частотному словарю:')
  dict(zip(train_text[1].replace('\ufeff', '').split()[:10], seq_train[1][:10]))

  def print_text_stats(title, texts, sequences, class_labels=writers):
      chars = 0
      words = 0

      print(f'Статистика по {title} текстам:')

      for cls in range(len(class_labels)):
          print(f'{class_labels[cls]:<15} {len(texts[cls]):9} символов,{len(sequences[cls]):8} слов')
          chars += len(texts[cls])
          words += len(sequences[cls])

      print('----')
      print(f'{"В сумме":<15} {chars:9} символов,{words:8} слов\n')   

  print_text_stats('обучающим', train_text, seq_train)
  print_text_stats('тестовым', test_text, seq_test)

  def split_sequence(sequence, win_size, hop):
      return [sequence[i:i + win_size] for i in range(0, len(sequence) - win_size + 1, hop)]

  def vectorize_sequence(seq_list, win_size, hop):
      ClassCount = len(seq_list)

      x, y = [], []

      for cls in range(ClassCount):
          vectors = split_sequence(seq_list[cls], win_size, hop)
          x += vectors
          y += [utils.to_categorical(cls, ClassCount)] * len(vectors)

      return np.array(x), np.array(y)

  def split_sequence(sequence, win_size, hop):
      return [sequence[i:i + win_size] for i in range(0, len(sequence) - win_size + 1, hop)]

  arr = np.arange(100)

  vec = split_sequence(arr, win_size=20, hop=10)
  print(np.array(vec))
  print()
  print(vec)

  def vectorize_sequence(seq_list, win_size, hop):
      ClassCount = len(seq_list)
      x, y = [], []

      for cls in range(ClassCount):
          vectors = split_sequence(seq_list[cls], win_size, hop)
          x += vectors
          y += [utils.to_categorical(cls, ClassCount)] * len(vectors)
      return np.array(x), np.array(y)

  x1 = []

  vec = split_sequence(arr, win_size=20, hop=10)
  x1 += vec

  vec = split_sequence(arr, win_size=20, hop=10)
  x1 += vec
  x2 = np.array(x1)
  print(x2)
  print(x2.shape)

  with timex():
      x_train, y_train = vectorize_sequence(seq_train, WIN_SIZE, WIN_HOP)
      x_test, y_test = vectorize_sequence(seq_test, WIN_SIZE, WIN_HOP)

      print(x_train.shape, y_train.shape)
      print(x_test.shape, y_test.shape)

  print('\nВывод отрезка индексов тренировочной выборки:')
  print(y_train[0])
  print(len(x_train[0]), end='\n\n')
  print(x_train[0][:100])
  print(x_train.shape)

  with timex():
      x_train_01 = tokenizer.sequences_to_matrix(x_train.tolist())
      x_test_01 = tokenizer.sequences_to_matrix(x_test.tolist())

      print(x_train_01.shape)
    
      print(x_train_01[0][0:100])

  print(x_train_01[0].shape)
  
  PART3_COMPLETE = True


def isReadyToTrain():
  if not PART1_COMPLETE:
    print("\nСначала выполните ЧАСТЬ 1")
    return False
  
  if not PART2_COMPLETE:
    print("\nСначала выполните ЧАСТЬ 2")
    return False
  
  if not PART3_COMPLETE:
    print("\nСначала выполните ЧАСТЬ 3")
    return False
  
  return True
  
  
### ФУНКЦИИИ ДЛЯ ЧАСТИ 4
def compile_train_model(model,
                        x_train,
                        y_train,
                        x_val,
                        y_val,
                        optimizer='adam',
                        epochs=50,
                        batch_size=128,
                        figsize=(20, 5)):

    model.compile(optimizer=optimizer,
                  loss='categorical_crossentropy',
                  metrics=['accuracy'])

    model.summary()

    history = model.fit(x_train,
                        y_train,
                        epochs=epochs,
                        batch_size=batch_size,
                        validation_data=(x_val, y_val))

    fig, (ax1, ax2) = plt.subplots(1, 2, figsize=figsize)
    fig.suptitle('График процесса обучения модели')
    ax1.plot(history.history['accuracy'],
               label='Доля верных ответов на обучающем наборе')
    ax1.plot(history.history['val_accuracy'],
               label='Доля верных ответов на проверочном наборе')
    ax1.xaxis.get_major_locator().set_params(integer=True)
    ax1.set_xlabel('Эпоха обучения')
    ax1.set_ylabel('Доля верных ответов')
    ax1.legend()

    ax2.plot(history.history['loss'],
               label='Ошибка на обучающем наборе')
    ax2.plot(history.history['val_loss'],
               label='Ошибка на проверочном наборе')
    ax2.xaxis.get_major_locator().set_params(integer=True)
    ax2.set_xlabel('Эпоха обучения')
    ax2.set_ylabel('Ошибка')
    ax2.legend()
    plt.show()

def eval_model(model, x, y_true,
               class_labels=[],
               cm_round=3,
               title='',
               figsize=(10, 10)):
    plt.style.use('default')

    y_pred = model.predict(x)

    cm = confusion_matrix(np.argmax(y_true, axis=1),
                          np.argmax(y_pred, axis=1),
                          normalize='true')
    cm = np.around(cm, cm_round)

    fig, ax = plt.subplots(figsize=figsize)
    ax.set_title(f'Нейросеть {title}: матрица ошибок нормализованная', fontsize=18)
    disp = ConfusionMatrixDisplay(confusion_matrix=cm, display_labels=class_labels)
    disp.plot(ax=ax)
    plt.gca().images[-1].colorbar.remove() 
    plt.xlabel('Предсказанные классы', fontsize=16)
    plt.ylabel('Верные классы', fontsize=16)
    fig.autofmt_xdate(rotation=45)         
    plt.show()

    print('-'*100)
    print(f'Нейросеть: {title}')

    for cls in range(len(class_labels)):
        cls_pred = np.argmax(cm[cls])
        msg = 'ВЕРНО :-)' if cls_pred == cls else 'НЕВЕРНО :-('
        print('Класс: {:<20} {:3.0f}% сеть отнесла к классу {:<20} - {}'.format(class_labels[cls],
                                                                               100. * cm[cls, cls_pred],
                                                                               class_labels[cls_pred],
                                                                               msg))
    print('\nСредняя точность распознавания: {:3.0f}%'.format(100. * cm.diagonal().mean()))

def compile_train_eval_model(model,
                             x_train,
                             y_train,
                             x_test,
                             y_test,
                             class_labels=writers,
                             title='',
                             optimizer='adam',
                             epochs=50,
                             batch_size=128,
                             graph_size=(20, 5),
                             cm_size=(10, 10)):
    compile_train_model(model,
                        x_train, y_train,
                        x_test, y_test,
                        optimizer=optimizer,
                        epochs=epochs,
                        batch_size=batch_size,
                        figsize=graph_size)
    eval_model(model, x_test, y_test,
               class_labels=class_labels,
               title=title,
               figsize=cm_size)
### КОНЕЦ ФУНКЦИИИ ДЛЯ ЧАСТИ 4


MENU_SHOW_OR_RUN = \
  """
  Показать выполненный результат или выполнить заново?
  1. Показать результат
  2. Выполнить заново
  
  Выберите пункт меню:\n
  """
  
def show_or_run():
  while True:
    option = int(input(MENU_SHOW_OR_RUN))
    match option:
      case 1:
        return 1
      case 2:
        return 2
      case _:
        print("Неверный пункт меню")


class TrainMethodEnum(StrEnum):
  BOW = 'bow'
  EMBEDDING_20 = 'embedding_20'
  EMBEDDING_200 = 'embedding_200'
  EMBEDDING_200_NR = 'embedding_200_nr'


def show_result(train_method: TrainMethodEnum):
  os.system(f'open ./images/{train_method}/graph.png')
  os.system(f'open ./images/{train_method}/matrix.png')
  os.system(f'open ./images/{train_method}/accuracy.png')


def part4_1():
  option = show_or_run()
  if option == 1:
    show_result(TrainMethodEnum.BOW)
  else:
    if not isReadyToTrain():
      return
    
    # Создание последовательной модели нейросети
    model_text_bow_softmax = Sequential()
    # Первый полносвязный слой
    model_text_bow_softmax.add(Dense(200, input_dim=MAX_WORDS_COUNT, activation="relu"))
    # Слой регуляризации Dropout
    model_text_bow_softmax.add(Dropout(0.25))
    # Слой пакетной нормализации
    model_text_bow_softmax.add(BatchNormalization())
    # Выходной полносвязный слой
    model_text_bow_softmax.add(Dense(ClassCount, activation='softmax'))

    # Входные данные подаются в виде векторов bag of words
    compile_train_eval_model(model_text_bow_softmax,
                            x_train_01, y_train,
                            x_test_01, y_test,
                            class_labels=writers,
                            title='BoW')
  
  
def part4_2():
  option = show_or_run()
  if option == 1:
    show_result(TrainMethodEnum.EMBEDDING_20)
  else:
    if not isReadyToTrain():
      return
    
    # Архитектура со слоем Embedding и регуляризацией
    model_text_emb_20 = Sequential()
    model_text_emb_20.add(Embedding(input_dim = MAX_WORDS_COUNT, output_dim = 20, input_length=WIN_SIZE))
    model_text_emb_20.add(SpatialDropout1D(0.2))
    model_text_emb_20.add(Flatten())
    model_text_emb_20.add(BatchNormalization())
    model_text_emb_20.add(Dense(200, activation="relu"))
    model_text_emb_20.add(Dropout(0.2))
    model_text_emb_20.add(BatchNormalization())
    model_text_emb_20.add(Dense(ClassCount, activation='softmax'))

    # Входные данные подаются в виде последовательностей индексов,
    # а не векторов bag of words
    compile_train_eval_model(model_text_emb_20,
                            x_train, y_train,
                            x_test, y_test,
                            class_labels=writers,
                            title='Embedding/20')
  
  
def part4_3():
  option = show_or_run()
  if option == 1:
    show_result(TrainMethodEnum.EMBEDDING_200)
  else:
    if not isReadyToTrain():
      return
    
    #Создаём сеть с Embedding слоем
    model_text_emb_200 = Sequential()
    model_text_emb_200.add(Embedding(MAX_WORDS_COUNT, 200, input_length=WIN_SIZE))
    model_text_emb_200.add(SpatialDropout1D(0.2))
    model_text_emb_200.add(Flatten())
    model_text_emb_200.add(BatchNormalization())
    model_text_emb_200.add(Dense(200, activation="relu"))
    model_text_emb_200.add(Dropout(0.2))
    model_text_emb_200.add(BatchNormalization())
    model_text_emb_200.add(Dense(ClassCount, activation='softmax'))

    compile_train_eval_model(model_text_emb_200,
                            x_train, y_train,
                            x_test, y_test,
                            class_labels=writers,
                            title='Embedding/200')
  

def part4_4():
  option = show_or_run()
  if option == 1:
    show_result(TrainMethodEnum.EMBEDDING_200_NR)
  else:
    if not isReadyToTrain():
      return
    
    #Создаём сеть с Embedding слоем
    model_text_emb_200_nr = Sequential()
    model_text_emb_200_nr.add(Embedding(MAX_WORDS_COUNT, 200, input_length=WIN_SIZE))
    model_text_emb_200_nr.add(Flatten())
    model_text_emb_200_nr.add(BatchNormalization())
    model_text_emb_200_nr.add(Dense(200, activation="relu"))
    model_text_emb_200_nr.add(BatchNormalization())
    model_text_emb_200_nr.add(Dense(ClassCount, activation='softmax'))

    compile_train_eval_model(model_text_emb_200_nr,
                            x_train, y_train,
                            x_test, y_test,
                            class_labels=writers,
                            epochs=50,
                            title='Embedding/200 без регуляризации')
  

def main():
  while True:
    option = int(input(menu))
    match option:
      case 0:
        break
      case 1:
        download()
      case 2:
        showText()
      case 3:
        part1()
      case 4:
        part2()
      case 5:
        part3()
      case 6:
        part4_1()
      case 7:
        part4_2()
      case 8:
        part4_3()
      case 9:
        part4_4()
      case _:
        print("Неверный пункт меню")


if __name__ == "__main__":
  main()
