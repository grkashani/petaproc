import 'package:flutter/material.dart';

const webPageSize = 600;

const mobileBackgroundColor = Color.fromRGBO(0, 0, 0, 1);
const webBackgroundColor = Color.fromRGBO(18, 18, 18, 1);
const mobileSearchColor = Color.fromRGBO(38, 38, 38, 1);
const blueColor = Color.fromRGBO(0, 149, 246, 1);
const primaryColor = Colors.white;
const secondaryColor = Colors.grey;

const dividerShort =
    '=================================================================================================================';
const divider =
    '-----------------------------------------------------------------------------------------------------------------';
const colorATS1 = Color(0xffea2064);
const colorATS2 = Color(0xfff67c03);
const colorATS3 = Color(0xff646489);

const sideMenuFontColor = Colors.black;
const sideMenuIconColor = Colors.black;
const sideMenuBackgroundColor = Colors.white;

const bgColor = Colors.white;
const bottonColor = Color(0xffc40404);
const appBarDownColor = Color(0xff952a2a);
const sideMenupinkColor = Color(0xffd7d8e1);
const sideMenugreyColor = Color(0xffeeeffa);
const borderColor = Color(0xffd4d5dc);
const menugreyColor = Color(0xffe0e3fd);
const menuItemColor = Color(0xffeeeffa);
const filterReportViewIconColor = Color(0xff952a2a);
const bakeReportViewColor = Color(0xffeeeffa);
const defaultPadding = 16.0;
const bottonCustomerListFacilityInstallment = Color(0xffc5fceb);
const bottonOrganizationListFacilityInstallment = Color(0xffc5fceb);

const iranSansBold = 'IRANSansX-Bold';
const iranSansLight = 'IRANSansX-Light';

const displayServiceOutput = false;
const outputHTML = false;

enum DashboardMenuItemEnum {
  empty,
  conditionAnalyze,
  conditionSalesAnalysis,
  conditionFeeAnalysis,
  reportCustomerList,
  reportListOrganizations,
  reportListRecipients,
  reportDesignCards,
  reportCreditorFinancialTransactions,
  reportAcceptorsFinancialTransactions,
  reportAcceptorsFinancialTransactionsBranch,
  reportAcceptorsFinancialTransactionsStore,
  reportAcceptorsFinancialTransactionsZC,
  reportAcceptorsFinancialTransactionsBranchZC,
  reportAcceptorsFinancialTransactionsStoreZC,
  reportPeriodicPaymentsAcceptors,
  reportPeriodicPaymentsSuppliers,
  reportFeesReceivedFromOrganization,
  reportFeeReceivedFromBorrower,
  reportFeeReceivedFromSupplier,
  reportFeePaidToBank,
  reportFeePaidToSupplier,
  reportFeesPaidToBusinessPartners,
  reportInstallmentInformation,
  reportLoanInformation,
  settingsProfile,
  settingsChangePassword,
  settingsRecordFeedback,
  exit,
}

List<String> phraseWords = [
  'salam',
  'reza',
  'kashani',
  'hastam',
  'salam',
  'shahin',
  'samiee',
  'hastam',
  'salam',
  'esmaeel',
  'tahermirzaee',
  'hastam'
];

enum Act { empty, successful, unsuccessful }

enum ChangePasword { change, login }

enum DateTimePart { date, year, month, day, time, hour, minute, second, monthname }

enum OutputType { dateTime, date, time, amountEn, amountFa, card, decimal, none }

enum TransactionDuration { lastMonth, last3Month, last6Month, lastYear, inDate, allHistory }

enum Durationn { fromDate, toDate }

enum PageSizePDF { a4, a5, a6 }

enum OrientationPDF { portrait, landscape }

enum PagePosition { header, footer }

enum TransactionAmount { all, graterThan, lessThan, equal, between }

enum FromToAmount { from, to }

enum JalaliDateType { now, lastLogin }

enum ViewState { homePage, dashboardPage }

enum AuthenticationState { welcoming, signIn, signUp, forGotPass, confirmationCod }

enum DashboardMenuEnum { status, report, financialTransaction }

enum MenuItemDetails {
  none,
  details,
  terminals,
  contracts,
  file,
  personnel,
  installments,
  cards,
  validation,
  documentation,
  transactions,
  guarantees,
  financial,
  job,
  billingTransactionDetails,
}

enum MenuItemBoxBottomCustomer { customerProfile, fileInformation, cardInformation, installmentInformation }

enum MenuItemBoxBottomBorrower { transactionDetails }

enum AcceptorTransaction { acceptor, branch, store, acceptorZC, branchZC, storeZC }

enum Functionality { pageNumberByStep, pageNumberDirect }

enum Columns { left, right }

enum NameProviderCurrent {
  none,
  customer,
  organizations,
  recipients,
  borrower,
  acceptor,
  acceptorBranch,
  acceptorStore,
  acceptorZC,
  acceptorBranchZC,
  acceptorStoreZC,
  periodicPaymentsAcceptors
}

enum BranchDropdownStatus { forTerminals }

enum ReportService { none, storeContractType2Invoice, storeContractType2InvoiceDetail }
enum  MainPageState{ home, network, post, notifications, jobs }
enum  WhichDialog{ addQuestion, certificateName }
