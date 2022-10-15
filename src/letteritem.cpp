#include "letteritem.h"

LetterItem::LetterItem(QObject *parent)
    : QObject{parent}
{

}

LetterItem::LetterItem(const QString &dec, const QString &enc, bool state, int count)
    : m_dec(dec),
      m_enc(enc),
      m_state(state),
      m_count(count)
{

}

const QString &LetterItem::dec() const
{
    return m_dec;
}

void LetterItem::setDec(const QString &newDec)
{
    m_dec = newDec;
}

const QString &LetterItem::enc() const
{
    return m_enc;
}

void LetterItem::setEnc(const QString &newEnc)
{
    m_enc = newEnc;
}

bool LetterItem::state() const
{
    return m_state;
}

void LetterItem::setState(bool newState)
{
    m_state = newState;
}

int LetterItem::count() const
{
    return m_count;
}

void LetterItem::setCount(int newCount)
{
    m_count = newCount;
}
