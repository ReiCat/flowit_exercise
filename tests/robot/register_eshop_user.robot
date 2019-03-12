*** Settings ***
Library           SeleniumLibrary        timeout=10
Library           ../src/functions.py
Suite Teardown   Close Browser


*** Variables ***
${BROWSER}          Firefox
${INDEX PAGE}       http://automationpractice.com/index.php

${SLEEP}            2s

${LOGIN_TITLE}      Login - My Store
${ACCOUNT_TITLE}    My account - My Store



*** Test Cases ***
Get Error Message With Invalid Email
    Sign In With Email                  asdasdasd@asd
    Wait Until Page Contains            Invalid email address.
    [Teardown]                          Close Browser

Get Error Messages With Valid Email And Empty Fields
    ${email}                            get email
    Sign In With Email                  ${email}

    # Wait for form to load properly
    Sleep                               ${SLEEP}
    Title Should Be                     Login - My Store
    Textfield Value Should Be           id:email                    ${email}

    # We're clearing email field to check if error will appear
    Clear Element Text                  id:email
    Clear Element Text                  id:alias

    # Deselect coutry set by default
    Click Element                       //select[@id='id_country']/option

    Click Button                        submitAccount

    Wait Until Page Contains            firstname is required.
    Wait Until Page Contains            lastname is required.
    Wait Until Page Contains            passwd is required.
    Wait Until Page Contains            email is required.
    Wait Until Page Contains            address1 is required.
    Wait Until Page Contains            city is required.
    Wait Until Page Contains            id_country is required.
    Wait Until Page Contains            You must register at least one phone number.
    Wait Until Page Contains            alias is required.
    [Teardown]                          Close Browser

Get Error Messages With Valid Email And Invalid Fields
    ${email}                            get email
    Sign In With Email                  ${email}

    # Wait for form to load properly
    Sleep                               ${SLEEP}

    Title Should Be                     ${LOGIN_TITLE}
    Textfield Value Should Be           id:email                    ${email}

    # Clear email before insert an invalid value
    Clear Element Text                  id:email

    Find Field And Insert Value         id:email                    asdasdasd@asd
    Find Field And Insert Value         id:phone_mobile             5555ss55
    Find Field And Insert Value         id:passwd                   5555

    # Check if US is selected by default
    ${selected_country}                 Get Selected List Value     //select[@id="id_country"]
    Should Be Equal                     ${selected_country}         21

    Find Field And Insert Value         id:postcode                 5555

    Click Button                        submitAccount

    Wait Until Page Contains            email is invalid.
    Wait Until Page Contains            phone_mobile is invalid.
    Wait Until Page Contains            passwd is invalid.
    Wait Until Page Contains            The Zip/Postal code you've entered is invalid. It must follow this format: 00000
    [Teardown]                          Close Browser

Check If All Possible Fields Are Filled Successfully
    ${first_name}                       get first name
    ${last_name}                        get last name
    ${email}                            get email
    ${password}                         get password
    ${company}                          get company
    ${address}                          get address
    ${city}                             get city
    ${zipcode}                          get zipcode

    Sign In With Email                  ${email}

    # Wait for form to load properly
    Sleep                               ${SLEEP}

    Title Should Be                     ${LOGIN_TITLE}
    Textfield Value Should Be           id:email                    ${email}

    ${number}                           get random number           2
    ${random_gender}                    Catenate                    SEPARATOR=      id:id_gender        ${number}
    Click Element                       ${random_gender}

    Find Field And Insert Value         id:customer_firstname       ${first_name}
    Find Field And Insert Value         id:customer_lastname        ${last_name}
    Find Field And Insert Value         id:passwd                   ${password}

    Select Random Element From List     //select[@id="days"]
    Select Random Element From List     //select[@id="months"]
    Select Random Element From List     //select[@id="years"]

    Select Checkbox                     id:newsletter
    Select Checkbox                     id:optin

    # YOUR ADDRESS section

    Find Field And Insert Value         id:firstname                ${first_name}
    Find Field And Insert Value         id:lastname                 ${last_name}
    Find Field And Insert Value         id:company                  ${company}
    Find Field And Insert Value         id:address1                 ${address}

    # Check if US is selected by default
    ${selected_country}                 Get Selected List Value     //select[@id="id_country"]
    Should Be Equal                     ${selected_country}         21

    Find Field And Insert Value         id:city                     ${city}
    Select Random Element From List     //select[@id="id_state"]
    Find Field And Insert Value         id:postcode                 ${ZIPCODE}
    Find Field And Insert Value         id:phone_mobile             555 5555
    Textfield Value Should Be           id:alias                    My address

    Click Button                        submitAccount

    # Wait for form to load properly
    Sleep                               ${SLEEP}

    # Check if we've logged in automatically
    Title Should Be                     ${ACCOUNT_TITLE}
    ${name}                             Catenate                    ${first_name}       ${last_name}
    Wait Until Page Contains            ${name}

    Click Link                          Sign out

    # Wait for page to load properly
    Sleep                               ${SLEEP}

    Title Should Be                     ${LOGIN_TITLE}

    # Try to relogin

    Find Field And Insert Value         id:email                    ${email}
    Find Field And Insert Value         id:passwd                   ${password}
    Click Button                        id:SubmitLogin

    # Wait for page to load properly
    Sleep                               ${SLEEP}

    Title Should Be                     ${ACCOUNT_TITLE}
    Wait Until Page Contains            ${name}

    [Teardown]                          Close Browser


*** Keywords ***
Sign In With Email
    [Arguments]                         ${email}
    Go To Index Page
    Find And Click Sign In Link
    Find Field And Insert Value         id:email_create             ${email}
    Click Button                        id:SubmitCreate

Go To Index Page
    Open Browser                        ${INDEX PAGE}               ${BROWSER}
    Title Should Be                     My Store

Find And Click Sign In link
    Element Should Be Visible           //header/div[2]/div/div/nav/div[1]/a
    Click Link                          //header/div[2]/div/div/nav/div[1]/a
    Title Should Be                     ${LOGIN_TITLE}

Find Field And Insert Value
    [Arguments]                         ${field}                    ${value}
    Element Should Be Visible           ${field}
    Input Text                          ${field}                    ${value}


Select Random Element From List
    [Arguments]                         ${element_id}
    ${list_length}                      Get Element Count           ${element_id}/option
    Should Be True                      ${list_length} > 1
    ${number}                           get random number           ${list_length}
    Should Be True                      ${number} >= 1
    Click Element                       ${element_id}/option[${number}]
