/**@jsxImportSource @emotion/react */
import * as s from './style';
import React from 'react';
import { FiChevronsLeft } from "react-icons/fi";
import { basicButton, emptyButton } from '../../../styles/buttons';
import { useRecoilState } from 'recoil';
import { mainSidebarIsOpenState } from '../../../atoms/mainSidebar/mainSidebarAtom';
import { LuLockKeyhole } from "react-icons/lu";
import { useUserMeQuery } from '../../../queries/userQuery';
import { Link, useNavigate } from 'react-router-dom';
import { BiEdit, BiLogOut } from "react-icons/bi";
import { setTokenLocalStorage } from '../../../configs/axiosConfig';
import { useQueryClient } from '@tanstack/react-query';
import Swal from 'sweetalert2';
import { useGetCategories } from '../../../queries/boardQuery';

function MainSidebar(props) {
    const navigate = useNavigate(); // 네비게이션을 위해 useNavigate 훅 사용
    const [ isOpen, setOpen ] = useRecoilState(mainSidebarIsOpenState); // 사이드바 상태 관리
    const queryClient = useQueryClient(); // React Query의 queryClient 사용
    const loginUserData = queryClient.getQueryData(["userMeQuery"]); // 로그인된 사용자 데이터 가져오기
    const categories = useGetCategories(); // 게시판 카테고리 정보 가져오기

    // 사이드바 닫기
    const handleSidebarClose = () => {
        setOpen(false);
    }

    // 계정 설정 페이지로 이동
    const handleAccountButtonOnClick = () => {
        navigate("/account/setting");
    }

    // 로그아웃 처리
    const handleLogoutButtonOnClick = async () => {
        setTokenLocalStorage("AccessToken", null); // 로컬 스토리지에서 토큰 삭제
        await queryClient.invalidateQueries({queryKey: ["userMeQuery"]}); // 로그인 정보 invalidate
        navigate("/auth/login"); // 로그인 페이지로 리디렉션
    }

    // 게시글 작성 페이지로 이동 (카테고리 선택)
    const handleWriteOnClick = async (categoryName) => {
        if(!categoryName) {
            const categoryData = await Swal.fire({
                title: "카테고리명을 입력하세요",
                input: "text",
                inputPlaceholder: "Enter category name...",
                showCancelButton: true,
                confirmButtonText: "작성하기",
                cancelButtonText: "취소하기"
            });
            if(categoryData.isConfirmed) {
                categoryName = categoryData.value;
            } else {
                return;
            }
        }
        navigate(`/board/write/${categoryName}`); // 작성 페이지로 이동
    }

    return (
        <div css={s.layout(isOpen)}>
            <div css={s.container}>
                <div>
                    <div css={s.groupLayout}>
                        <div css={s.topGroup}>
                            <div css={s.user}>
                                <button css={emptyButton} onClick={handleAccountButtonOnClick}>
                                    <span css={s.authText}>
                                        <div css={s.profileImgBox}>
                                            <img src={`http://localhost:8080/image/user/profile/${loginUserData?.data.profileImg}`} alt="" />
                                        </div>
                                        <span>{loginUserData?.data.nickname}</span>
                                    </span>
                                </button>
                            </div>
                            <button css={basicButton} onClick={handleSidebarClose}><FiChevronsLeft /></button> {/* 사이드바 닫기 버튼 */}
                        </div>
                    </div>
                    <div css={s.groupLayout}>
                        <Link to={"/board/list?page=1&order=recent&searchText="}>
                            <button css={emptyButton}>
                                <span>
                                    전체 게시글
                                </span>
                            </button>
                        </Link>
                    </div>
                    <div css={s.groupLayout}>
                        <button css={emptyButton}>
                            <span>
                                공지사항
                            </span>
                        </button>
                    </div>
                    <div css={s.groupLayout}>
                        <div css={s.categoryItem}>
                            <button css={emptyButton}>내가 작성한 글({categories.isLoading || categories.data.data.reduce((prev, category) => {return prev + category.boardCount}, 0)})</button>
                            <button css={basicButton} onClick={() => handleWriteOnClick(null)}><BiEdit /></button> {/* 글 작성 버튼 */}
                        </div>
                    </div>
                </div>
                <div css={s.categoryListContainer}>
                    {
                        categories.isLoading ||
                        categories.data.data.map(category =>
                            <div key={category.boardCategoryId} css={s.groupLayout}>
                                <div css={s.categoryItem}>
                                    <button css={emptyButton}>{category.boardCategoryName}({category.boardCount})</button>
                                    <button css={basicButton} onClick={() => handleWriteOnClick(category.boardCategoryName)}><BiEdit /></button> {/* 각 카테고리별 글 작성 버튼 */}
                                </div>
                            </div>
                        )
                    }
                </div>
                <div>
                    <div css={s.groupLayout}>
                        <button css={emptyButton} onClick={handleLogoutButtonOnClick}>
                            <span css={s.authText}>
                                <BiLogOut /> 로그아웃
                            </span>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    );
}

export default MainSidebar;