import MeCab
import copy

def mecabParser(sentence):

    mecabConvertSentence = ''
    mecabSentence = []
    mecabTokenizedSentence = []
    #mecab-Ko 관련 변수
    mecabFindTagList = [
                "NNG",
                "NNP",
                "NNB",
                "NNBC",
                "NR",
                "NP",
                "VV",
                "VA",
                "VX",
                "VA+ETM",
                "VX+ETM",
                "VCN",
                "MM",
                "MAG",
                "XPN",
                "SY",
                "SL",
                "SH",
                "SSO",
                "SSC",
                "SN", ]
    mecab = MeCab.Tagger('-d /usr/local/lib/mecab/dic/mecab-ko-dic')

    # mecab-ko 로 형태소 분석을 시작
    if len(sentence.strip()) > 0 :
        mecabParse = mecab.parse(sentence).split("\n")
        for word in mecabParse:
            wordAnalys = word.split("\t")
            # 불필요한 EOS, 공백 문자 제거
            if wordAnalys[0] != "EOS" and len(wordAnalys[0]) > 0:
                if wordAnalys[1].split(",")[0] in mecabFindTagList or wordAnalys[1].split(",")[0].startswith("VV+"):
                    mecabTokenizedSentence.append(wordAnalys[0])
        mecabSentence.append(copy.deepcopy(mecabTokenizedSentence))
        mecabTokenizedSentence.clear()

    # print("-"*100)

    # 형태소가 분석되어 나눠진 단어를 문장으로 합쳐서 배열에 입력
    # 합칠때 ' ' 으로 구분하여 합쳐짐
    for line in mecabSentence:
        mecabConvertSentence = (' '.join(str(e) for e in line))

    return mecabConvertSentence;


if __name__ == '__main__':
    print(mecabParser("로그인을 한"))