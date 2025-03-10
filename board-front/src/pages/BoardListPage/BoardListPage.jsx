/**@jsxImportSource @emotion/react */
import Select from 'react-select';
import * as s from './style';
import { BiSearch } from 'react-icons/bi';
import { emptyButton } from '../../styles/buttons';
import { GrView } from 'react-icons/gr';
import { FcLike } from 'react-icons/fc';
import { GoChevronLeft, GoChevronRight } from 'react-icons/go';
import { useEffect, useState } from 'react';
import { useSearchParams } from 'react-router-dom';
import { useGetSearchBoardList } from '../../queries/boardQuery';

function BoardListPage(props) {
    const [ searchParams, setSearchParams ] = useSearchParams(); 
    const page = parseInt(searchParams.get("page") || "1"); // 페이지 번호
    const order = searchParams.get("order") || "recent"; // 정렬 기준
    const searchText = searchParams.get("searchText") || ""; // 검색 텍스트

    const searchBoardList = useGetSearchBoardList({
        page,
        limitCount: 15,
        order,
        searchText,
    });

    const [ pageNumbers, setPageNumbers ] = useState([]); // 페이지 번호 배열
    const [ searchInputValue, setSearchInputValue ] = useState(searchText); // 검색 입력 값

    const orderSelectOptions = [
        {label: "최근 게시글", value: "recent"},
        {label: "오래된 게시글", value: "oldest"},
        {label: "조회수 많은 순", value: "viewsDesc"},
        {label: "조회수 적은 순", value: "viewsAsc"},
        {label: "좋아요 많은 순", value: "likesDesc"},
        {label: "좋아요 적은 순", value: "likesAsc"},
    ];

    // 게시판 리스트를 가져오고 페이지 번호를 설정하는 useEffect
    useEffect(() => {
        if(!searchBoardList.isLoading) {
            const currentPage = searchBoardList?.data?.data.page || 1; // || : 앞에가 펄스면 뒤에껄로
            const totalPages = searchBoardList?.data?.data.totalPages || 1;
            const startIndex = Math.floor((currentPage - 1) / 5) * 5 + 1;
            const endIndex = startIndex + 4 > totalPages ? totalPages : startIndex + 4;

            let newPageNumbers = []; // 빈 배열을 선언
            for(let i = startIndex; i <= endIndex; i++) {
                newPageNumbers = [...newPageNumbers, i]; // [1]... [1,2]... [1,2,3]...
            }
            setPageNumbers(newPageNumbers); // 페이지 번호 업데이트
        }
    }, [searchBoardList.data]);

    // searchParams가 변경될 때마다 데이터를 다시 불러옴
    useEffect(() => {
        searchBoardList.refetch();
    }, [searchParams]);

    // 페이지 번호 클릭 시 처리
    const handlePageNumbersOnClick = (pageNumber) => {
        searchParams.set("page", pageNumber);
        setSearchParams(searchParams);
    }

    // 정렬 옵션 변경 시 처리
    const handleSelectOnChange = (option) => {
        searchParams.set("order", option.value);
        setSearchParams(searchParams);
    }

    // 검색 버튼 클릭 시 처리
    const handleSearchButtonOnClick = () => {
        searchParams.set("page", 1);
        searchParams.set("searchText", searchInputValue);
        setSearchParams(searchParams);
    }

    // 엔터 키로 검색 실행
    const handleSearchInputOnKeyDown = (e) => {
        if (e.keycode === 13) {
            handleSearchButtonOnClick();
        }
    }

    return (
        <div css={s.container}>
            {/* 헤더 부분 */}
            <div css={s.header}>
                <div css={s.title}>
                    <h2>전체 게시글</h2> {/* 제목 표시 */}
                </div>
                <div css={s.searchItems}>
                    {/* 정렬 옵션 선택 */}
                    <Select 
                        options={orderSelectOptions}
                        styles={{
                            control: (style) => ({
                                ...style,
                                width: "11rem",
                                minHeight: "3rem",
                            }),
                            dropdownIndicator: (style) => ({
                                ...style,
                                padding: "0.3rem",
                            })
                        }}
                        value={orderSelectOptions.find((option) => option.value === order)}
                        onChange={handleSelectOnChange}
                    />
                    {/* 검색 입력창 */}
                    <div css={s.searchInputBox}>
                        <input 
                            type="text" 
                            value={searchInputValue} 
                            onChange={(e) => setSearchInputValue(e.target.value)} 
                            onKeyDown={handleSearchInputOnKeyDown} 
                        />
                        <button css={emptyButton} onClick={handleSearchButtonOnClick}><BiSearch /></button>
                    </div>
                </div>
            </div>
    
            {/* 메인 리스트 부분 */}
            <div css={s.main}>
                <ul css={s.boardListContainer}>
                    {/* 게시글 리스트 헤더 */}
                    <li>
                        <div>No.</div>
                        <div>Title</div>
                        <div>Writer</div>
                        <div>Count</div>
                        <div>Date</div>
                    </li>
                    {/* 게시글 리스트 출력 */}
                    {
                        searchBoardList.isLoading || // 로딩 중이면 로딩 상태 유지
                        searchBoardList.data.data.boardSearchList.map(boardList => 
                            <li key={boardList.boardId}>
                                <div>{boardList.boardId}</div> {/* 게시글 번호 */}
                                <div>{boardList.title}</div> {/* 제목 */}
                                <div css={s.boardWriter}>
                                    <div>
                                        <img 
                                            src={`http://localhost:8080/image/user/profile/${boardList.profileImg || "default.png"}`} 
                                            alt="" 
                                        />
                                    </div>
                                    <span>{boardList.nickname}</span> {/* 작성자 닉네임 */}
                                </div>
                                <div css={s.boardCounts}>
                                    {/* 조회수 */}
                                    <span>
                                        <GrView />
                                        <span>{boardList.viewCount}</span>
                                    </span>
                                    {/* 좋아요 수 */}
                                    <span>
                                        <FcLike />
                                        <span>{boardList.likeCount}</span>
                                    </span>
                                </div>
                                <div>{boardList.createdAt}</div> {/* 작성 날짜 */}
                            </li>
                        )
                    }
                </ul>
            </div>
    
            {/* 페이지네이션 부분 */}
            <div css={s.footer}>
                <div css={s.pageNumbers}>
                    {/* 이전 페이지 버튼 */}
                    <button 
                        disabled={searchBoardList?.data?.data.firstPage} 
                        onClick={() => handlePageNumbersOnClick(page - 1)}
                    >
                        <GoChevronLeft />
                    </button>
                    
                    {/* 페이지 번호 버튼 */}
                    {
                        pageNumbers.map(number => 
                            <button 
                                key={number} 
                                css={s.pageNum(page === number)} 
                                onClick={() => handlePageNumbersOnClick(number)}
                            >
                                <span>{number}</span>
                            </button>
                        )
                    }
    
                    {/* 다음 페이지 버튼 */}
                    <button 
                        disabled={searchBoardList?.data?.data.lastPage} 
                        onClick={() => handlePageNumbersOnClick(page + 1)}
                    >
                        <GoChevronRight />
                    </button>
                </div>
            </div>
        </div>
    );    
}

export default BoardListPage;
