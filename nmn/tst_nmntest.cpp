#include <QString>
#include <QtTest>
#include <QCoreApplication>

class NmnTest : public QObject
{
    Q_OBJECT

public:
    NmnTest();

private Q_SLOTS:
    void testCase1();
};

NmnTest::NmnTest()
{
}

void NmnTest::testCase1()
{
    QVERIFY2(true, "Failure");
}

QTEST_MAIN(NmnTest)

#include "tst_nmntest.moc"
